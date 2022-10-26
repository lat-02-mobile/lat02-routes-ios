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
                for category in categories {
                    let categoriesEntity = self.localDataManager.getLineCategoryDataById( keyValue: category.id)
                    for categoryEntity in categoriesEntity {
                        let context = self.coreDataManager.getContext()
                        categoryEntity.blackIcon = category.blackIcon
                        categoryEntity.createAt = category.createAt.dateValue()
                        categoryEntity.id = category.id
                        categoryEntity.nameEsp = category.nameEsp
                        categoryEntity.nameEng = category.nameEng
                        categoryEntity.updateAt = category.updateAt.dateValue()
                        categoryEntity.whiteIcon = category.whiteIcon
                        do {
                            try context.save()
                        } catch {
                            self.update = false
                        }
                    }
                }
                self.updateLinesByDate()
            case.failure:
                self.update = false
            }
        }
    }
    func updateLinesByDate() {
        self.lineManager.getLinesForCurrentCityByDateGreaterThanOrEqualTo(date: self.lastUpdated) { result in
            switch result {
            case.success(let lines):
                self.update = true
                for line in lines {
                    let linesEntity = self.localDataManager.getLineDataById( keyValue: line.id)
                    self.updateRoutesByDate(lineId: line.id)
                    for lineEntity in linesEntity {
                        let context = self.coreDataManager.getContext()
                        lineEntity.createAt = line.createAt.dateValue()
                        lineEntity.id = line.id
                        lineEntity.idCategory = line.idCategory
                        lineEntity.name = line.name
                        lineEntity.updateAt = line.updateAt.dateValue()
                        do {
                            try context.save()
                        } catch {
                            self.update = false
                        }
                    }
                }
            case.failure:
                self.update = false
            }
        }
    }
    func updateRoutesByDate(lineId: String) {
        lineRouteManager.getLineRouteByDateGreaterThanOrEqualTo(idLine: lineId, date: self.lastUpdated) { result in
            switch result {
            case.success(let lineRoutes):
                for lineRoute in lineRoutes {
                    let lineRoutesEntity = self.localDataManager.getLineRouteDataById( keyValue: lineRoute.id)
                    for lineRouteEntity in lineRoutesEntity {
                        let context = self.coreDataManager.getContext()
                        lineRouteEntity.averageVelocity = lineRoute.averageVelocity
                        lineRouteEntity.color = lineRoute.color
                        lineRouteEntity.createAt = lineRoute.createAt.dateValue()
                        lineRouteEntity.id = lineRoute.id
                        lineRouteEntity.idLine = lineRoute.idLine
                        lineRouteEntity.name = lineRoute.name
                        lineRouteEntity.end = lineRoute.end.toCoordinate()
                        lineRouteEntity.routePoints = lineRoute.routePoints.map({ $0.toCoordinate() })
                        lineRouteEntity.start = lineRoute.start.toCoordinate()
                        lineRouteEntity.stops = lineRoute.stops.map({ $0.toCoordinate() })
                        do {
                            try context.save()
                        } catch {
                            self.update = false
                        }
                    }
                }
                self.update = true
                self.updateDataValueForSync()
            case.failure:
                self.update = false
            }
        }
    }
    func updateTourPoint() {
        tourpointsManager.getTourpointListByDateGreaterThanOrEquelTo(date: self.lastUpdated) { result in
            switch result {
            case.success(let tourpoints):
                self.update = true
                for tourpoint in tourpoints {
                    let tourpointsEntity = self.localDataManager.getTourPointDataById( keyValue: tourpoint.id)
                    for tourpointEntity in tourpointsEntity {
                        let context = self.coreDataManager.getContext()
                        tourpointEntity.address = tourpoint.address
                        tourpointEntity.createdAt = tourpoint.createAt.dateValue()
                        tourpointEntity.id = tourpoint.id
                        tourpointEntity.name = tourpoint.name
                        tourpointEntity.destination = tourpoint.destination.toCoordinate()
                        tourpointEntity.updateAt = tourpoint.updateAt.dateValue()
                        tourpointEntity.urlImage = tourpoint.urlImage
                        do {
                            try context.save()
                        } catch {
                            self.update = false
                        }
                    }
                }
                self.updateTourpointCategories()
            case.failure:
                self.update = false
            }
        }
    }
    func updateTourpointCategories() {
        tourpointsManager.getTourpointCategoriesByDateGreaterThanOrEquelTo(date: self.lastUpdated) { result in
            switch result {
            case.success(let tourPointCategories):
                self.update = true
                for tourPointCategory in tourPointCategories {
                    let tourPointsCategoryEntity = self.localDataManager.getTourPointCategoryDataById( keyValue: tourPointCategory.id)
                    for tourPointCategoryEntity in tourPointsCategoryEntity {
                        let context = self.coreDataManager.getContext()
                        tourPointCategoryEntity.createdAt = tourPointCategory.createAt.dateValue()
                        tourPointCategoryEntity.descriptionEsp = tourPointCategory.descriptionEsp
                        tourPointCategoryEntity.descriptionEng = tourPointCategory.descriptionEng
                        tourPointCategoryEntity.icon = tourPointCategory.icon
                        tourPointCategoryEntity.id = tourPointCategory.id
                        tourPointCategoryEntity.updateAt = tourPointCategory.updateAt.dateValue()
                        do {
                            try context.save()
                        } catch {
                            self.update = false
                        }
                    }
                }
                self.updateDataValueForSync()
            case.failure:
                self.update = false
            }
        }
    }
    func updateDataValueForSync() {
        if update {
            self.localDataManager.updateDataValueForSync(entity: SyncUnitHistory.name, key: "id", keyValue: "0", keyUpdate: "lastUpdated") { _ in }
        }
    }
}
