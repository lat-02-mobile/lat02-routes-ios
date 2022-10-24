import Foundation
import BackgroundTasks

class SyncData {
    private let tourpointsManager = TourpointsManager.shared
    private let lineManager = LineFirebaseManager.shared
    private let lineRouteManager = LineRouteFirebaseManager.shared
    private let lineCategoryManager = LineCategoryFirebaseManager.shared
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.getContext()
    var localDataManager: LocalDataManagerProtocol = LocalDataManager.shared
    var lastUpdated = Date()
    let queue = DispatchQueue(label: "AllRoutes", attributes: .concurrent)
    var categoryEntities: [LineCategoryEntity] = []
    var update: Bool = false

    func syncData() {
        queue.async {
            self.localDataManager.getDataFromCoreData(type: SyncUnitHistory.self, forEntity: SyncUnitHistory.name) { result in
                switch result {
                case .success(let date):
                    if date.isEmpty {
                        let sync = SyncUnitHistoryModel(id: "0", lastUpdated: Date())
                        sync.toEntity(context: self.context)
                        try? self.context.save()
                        self.updateLineCategoryByDate()
                        self.updateTourPoint()
                    } else {
                        self.lastUpdated = date[0].lastUpdated ?? Date()
                        self.updateLineCategoryByDate()
                        self.updateTourPoint()
                    }
                case.failure:
                    self.update = false
                }
            }
        }
    }
    func updateLineCategoryByDate() {
        self.lineCategoryManager.getCategoriesByDate(date: self.lastUpdated) { result in
            switch result {
            case.success(let categories):
                self.update = true
                for categorie in categories {
                    let delete = self.localDataManager.deleteEntityObjectByKeyValue(type: LineCategoryEntity.self, key: "id", value: categorie.id)
                    if  delete == true {
                        _ = LinesCategory(id: categorie.id, nameEng: categorie.nameEng, nameEsp: categorie.nameEsp,
                                          blackIcon: categorie.blackIcon, whiteIcon: categorie.whiteIcon,
                                          updateAt: categorie.updateAt, createAt: categorie.createAt)
                            .toEntity(context: self.coreDataManager.getContext())
                    }
                    self.updateLinesByDate()
                }
            case.failure:
                self.update = false
            }
        }
    }
    func updateLinesByDate() {
        self.lineManager.getLinesForCurrentCityByDate(date: self.lastUpdated) { result in
            switch result {
            case.success(let lines):
                self.update = true
                for line in lines {
                    let delete = self.localDataManager.deleteEntityObjectByKeyValue(type: LineEntity.self, key: "id", value: line.id)
                    if  delete == true {
                        let newLine = Lines(categoryRef: line.categoryRef, enable: line.enable, id: line.id, idCity: line.idCity,
                                            idCategory: line.idCategory, name: line.name, updateAt: line.updateAt, createAt: line.createAt)
                        let lineEntity = newLine.toEntity(categories: self.categoryEntities, context: self.context)
                        self.updateRoutesByDate(line: lineEntity)
                    }
                }
            case.failure:
                self.update = false
            }
        }
    }
    func updateRoutesByDate(line: LineEntity) {
        lineRouteManager.getLineRouteByDate(idLine: line.id, date: self.lastUpdated) { result in
            switch result {
            case.success(let lineRoutes):
                for route in lineRoutes {
                    let delete = self.localDataManager.deleteEntityObjectByKeyValue(type: LineRouteEntity.self, key: "id", value: route.id)
                    if  delete == true {
                        route.toEntity(context: self.coreDataManager.getContext(), line: line)
                    }
                }
                self.update = true
                try? self.context.save()
                self.updateDataValueForSync()
            case.failure:
                self.update = false
            }
        }
    }
    func updateTourPoint() {
        if coreDataManager.deleteTourPoints() {
            tourpointsManager.getTourpointList { result in
                switch result {
                case.success(let tourpoints):
                    self.update = true
                    self.updateTourpointCategories(tourpoints: tourpoints)
                case.failure:
                    self.update = false
                }
            }
        }
    }
     func updateTourpointCategories(tourpoints: [Tourpoint]) {
         tourpointsManager.getTourpointCategoriesByDate(date: self.lastUpdated) { result in
             switch result {
             case.success(let categories):
                 let categoryEntities = categories.map({ $0.toEntity(context: self.coreDataManager.getContext()) })
                 for tourpoint in tourpoints {
                     tourpoint.toEntity(context: self.coreDataManager.getContext(), categories: categoryEntities)
                 }
                 self.update = true
                 try? self.context.save()
                 self.updateDataValueForSync()
             case.failure:
                 self.update = false
             }
         }
    }
    func updateDataValueForSync() {
        if update {
            self.localDataManager.updateDataValueForSync(entity: "SyncUnitHistory", key: "id", keyValue: "0", keyUpdate: "lastUpdated") { _ in }
        }
    }
}
