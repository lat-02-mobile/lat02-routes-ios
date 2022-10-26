//
//  LocalDataManager.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//

import Foundation
import CoreData
import Kingfisher

protocol LocalDataManagerProtocol {
    func retrieveAllDataFromFirebase(completion: @escaping(Result<Void, Error>) -> Void)
    func getDataFromCoreData<T: NSManagedObject>(type: T.Type, forEntity: String, completion: @escaping(Result<[T], Error>) -> Void)
    func updateDataValueForSync(entity: String, key: String, keyValue: String, keyUpdate: String, completion: @escaping(Result<Void, Error>) -> Void)
    func deleteEntityObjectByKeyValue<T: NSManagedObject>( type: T.Type, key: String, value: String) -> Bool
    func getLineCategoryDataById(keyValue: String) -> [LineCategoryEntity]
    func getLineDataById(keyValue: String) -> [LineEntity]
    func getLineRouteDataById(keyValue: String) -> [LineRouteEntity]
    func getTourPointCategoryDataById(keyValue: String) -> [TourpointCategoryEntity]
    func getTourPointDataById(keyValue: String) -> [TourpointEntity]
}

class LocalDataManager: LocalDataManagerProtocol {
    static let shared = LocalDataManager()
    private let tourpointsManager = TourpointsManager.shared
    private let lineManager = LineFirebaseManager.shared
    private let lineRouteManager = LineRouteFirebaseManager.shared
    private let lineCategoryManager = LineCategoryFirebaseManager.shared
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.getContext()
    func getDataFromCoreData<T: NSManagedObject>(type: T.Type, forEntity entity: String, completion: @escaping(Result<[T], Error>) -> Void) {
        coreDataManager.getData(type: type, entity: entity, completion: completion)
    }
    func updateDataValueForSync(entity: String, key: String, keyValue: String, keyUpdate: String, completion: @escaping(Result<Void, Error>) -> Void) {
        coreDataManager.updateDataValue(entity: entity, key: key, keyValue: keyValue, keyUpdate: keyUpdate,
                                        keyUpdateValue: Date(), completion: completion)
    }
    func deleteEntityObjectByKeyValue<T: NSManagedObject>(type: T.Type, key: String, value: String) -> Bool {
        return coreDataManager.deleteEntityObjectByKeyValue(entityName: type, key: key, value: value)
    }
    func getLineCategoryDataById(keyValue: String) -> [LineCategoryEntity] {
        let data: [LineCategoryEntity] = coreDataManager.getDataById(entity: LineCategoryEntity.name, key: "id", keyValue: keyValue)
        return data
    }
    func getLineDataById(keyValue: String) -> [LineEntity] {
        let data: [LineEntity] = coreDataManager.getDataById(entity: LineEntity.name, key: "id", keyValue: keyValue)
        return data
    }
    func getLineRouteDataById(keyValue: String) -> [LineRouteEntity] {
        let data: [LineRouteEntity] = coreDataManager.getDataById(entity: LineRouteEntity.name, key: "id", keyValue: keyValue)
        return data
    }
    func getTourPointCategoryDataById(keyValue: String) -> [TourpointCategoryEntity] {
        let data: [TourpointCategoryEntity] = coreDataManager.getDataById(entity: TourpointCategoryEntity.name, key: "id", keyValue: keyValue)
        return data
    }
    func getTourPointDataById(keyValue: String) -> [TourpointEntity] {
        let data: [TourpointEntity] = coreDataManager.getDataById(entity: TourpointEntity.name, key: "id", keyValue: keyValue)
        return data
    }
    func retrieveAllDataFromFirebase(completion: @escaping(Result<Void, Error>) -> Void) {
        if coreDataManager.deleteAll() {
            tourpointsManager.getTourpointList { result in
                switch result {
                case.success(let tourpoints):
                    self.getAndSaveTourpointCategoriesWithTourpoints(tourpoints: tourpoints, completion: completion)
                case.failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(CoreDataError.Failed(cause: String.localizeString(localizedString: ConstantVariables.errorUpdatingData))))
        }
    }
    private func getAndSaveTourpointCategoriesWithTourpoints(tourpoints: [Tourpoint], completion: @escaping(Result<Void, Error>) -> Void) {
        tourpointsManager.getTourpointCategories { result in
            switch result {
            case.success(let categories):
                let categoryEntities = categories.map({ $0.toEntity(context: self.coreDataManager.getContext()) })
                for tourpoint in tourpoints {
                    tourpoint.toEntity(context: self.coreDataManager.getContext(), categories: categoryEntities)
                }
                try? self.context.save()
                self.getLineCategories(completion: completion)
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    private func getLineCategories(completion: @escaping(Result<Void, Error>) -> Void) {
        lineCategoryManager.getCategories { result in
            switch result {
            case.success(let categories):
                let categoryEntities = categories.map({ $0.toEntity(context: self.coreDataManager.getContext()) })
                self.getLines(categories: categoryEntities, completion: completion)
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    private func getLines(categories: [LineCategoryEntity], completion: @escaping(Result<Void, Error>) -> Void) {
        lineManager.getLinesForCurrentCity { result in
            switch result {
            case.success(let lines):
                for line in lines where line.enable {
                    let lineEntity = line.toEntity(categories: categories, context: self.coreDataManager.getContext())
                    self.getLineRoutes(line: lineEntity, completion: completion)
                }
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    private func getLineRoutes(line: LineEntity, completion: @escaping(Result<Void, Error>) -> Void) {
        lineRouteManager.getLineRoute(idLine: line.id) { result in
            switch result {
            case.success(let lineRoutes):
                for route in lineRoutes {
                    route.toEntity(context: self.coreDataManager.getContext(), line: line)
                }
                try? self.context.save()
                completion(.success(()))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}
