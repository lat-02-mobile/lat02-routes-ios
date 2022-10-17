//
//  LocalDataManager.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//

import Foundation
import CoreData

protocol LocalDataManagerProtocol {
    func retrieveAllDataFromFirebase(completion: @escaping(Result<Void, Error>) -> Void)
    func getDataFromCoreData<T: NSManagedObject>(type: T.Type, forEntity: String, completion: @escaping(Result<[T], Error>) -> Void)
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

    func retrieveAllDataFromFirebase(completion: @escaping(Result<Void, Error>) -> Void) {
        let categoriesT: [TourpointCategoryEntity] = coreDataManager.getData(entity: TourpointCategoryEntity.name)
        let tourpoints: [TourpointEntity] = coreDataManager.getData(entity: TourpointEntity.name)
        let categoriesL: [LineCategoryEntity] = coreDataManager.getData(entity: LineCategoryEntity.name)
        let lines: [LineEntity] = coreDataManager.getData(entity: LineEntity.name)

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
