//
//  MockLocalDataManager.swift
//  RoutesApp_iosTests
//
//  Created by Yawar Valeriano on 10/13/22.
//

import CoreData
@testable import RoutesApp_ios

class MockLocalDataManager: LocalDataManagerProtocol {
    static func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }

        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
    }

    var context = setUpInMemoryManagedObjectContext()

    var dataHasBeenRetrieved = false
    var sendWithError = false
    var tourpointsCalled = false
    var tourpointsCategoryCalled = false
    var dataHasBeenUpdated = false

    func retrieveAllDataFromFirebase(completion: @escaping (Result<Void, Error>) -> Void) {
        if sendWithError {
            completion(.failure(NSError(domain: "Error", code: 0)))
        } else {
            dataHasBeenRetrieved = true
            completion(.success(()))
        }
    }

    func getDataFromCoreData<T: NSManagedObject>(type: T.Type, forEntity: String, completion: @escaping (Result<[T], Error>) -> Void) {
        if sendWithError {
            completion(.failure(NSError(domain: "Error", code: 0)))
            return
        }
        switch type {
        case is LineEntity.Type:
            let lines: [T] = convertLineToEntity()
            completion(.success(lines))
        case is LineCategoryEntity.Type:
            let categories: [T] = convertLineCategoryToEntity()
            completion(.success(categories))
        case is TourpointEntity.Type:
            tourpointsCalled = true
            let tourpoints: [T] = convertTourpointToEntity()
            completion(.success(tourpoints))
        case is TourpointCategoryEntity.Type:
            tourpointsCategoryCalled = true
            let categories: [T] = convertTourpointCategoryToEntity()
            completion(.success(categories))
        default:
            completion(.success([]))
        }

    }
    func updateDataValueForSync(entity: String, key: String, keyValue: String, keyUpdate: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if sendWithError {
            completion(.failure(NSError(domain: "Error", code: 0)))
        } else {
            dataHasBeenRetrieved = true
            completion(.success(()))
        }
    }

    func getLineCategoryDataById(keyValue: String) -> [LineCategoryEntity] {
        return TestResources.lineCategoryEntity
    }

    func getLineDataById(keyValue: String) -> [LineEntity] {
        return TestResources.lineEntity
    }

    func getLineRouteDataById(keyValue: String) -> [LineRouteEntity] {
        return TestResources.lineRouteEntity
    }

    func getTourPointCategoryDataById(keyValue: String) -> [TourpointCategoryEntity] {
        return TestResources.tourpointCategoryEntity
    }

    func getTourPointDataById(keyValue: String) -> [TourpointEntity] {
        return TestResources.tourpointEntity
    }

    func updateDataValueForSync(entity: String, key: String, keyValue: String, keyUpdate: String) {
        dataHasBeenUpdated = true
    }
    func deleteEntityObjectByKeyValue<T>(type: T.Type, key: String, value: String) -> Bool where T: NSManagedObject {
        if sendWithError {
            return true
        } else {
            return false
        }
    }

    private func convertLineToEntity<T>() -> [T] {
        return TestResources.lines.map({ line in
            let entity = LineEntity(context: context)
            entity.id = line.id
            entity.name = line.name
            entity.idCategory = line.idCategory
            entity.createAt = Date()
            entity.category = LineCategoryEntity(context: context)
            entity.updateAt = Date()
            // swiftlint:disable force_cast
            return entity as! T
        })
    }

    private func convertLineCategoryToEntity<T>() -> [T] {
        return TestResources.lineCategories.map({ category in
            let entity = LineCategoryEntity(context: context)
            entity.id = category.id
            entity.nameEng = category.nameEng
            entity.nameEsp = category.nameEsp
            entity.whiteIcon = category.whiteIcon
            entity.blackIcon = category.blackIcon
            entity.createAt = Date()
            entity.updateAt =  Date()
            // swiftlint:disable force_cast
            return entity as! T
        })
    }

    private func convertTourpointToEntity<T>() -> [T] {
        return TestResources.tourpoints.map({ tourpoint in
            let entity = TourpointEntity(context: context)
            entity.address = tourpoint.address
            entity.category = TourpointCategoryEntity(context: context)
            entity.createdAt = Date()
            entity.destination = tourpoint.destination.toCoordinate()
            entity.name = tourpoint.name
            entity.urlImage = tourpoint.urlImage
            entity.updateAt = Date()
            // swiftlint:disable force_cast
            return entity as! T
        })
    }

    private func convertTourpointCategoryToEntity<T>() -> [T] {
        return TestResources.tourpointCategories.map({ category in
            let entity = TourpointCategoryEntity(context: context)
            entity.id = category.id
            entity.descriptionEng = category.descriptionEng
            entity.descriptionEsp = category.descriptionEsp
            entity.icon = category.icon
            entity.createdAt = Date()
            // swiftlint:disable force_cast
            return entity as! T
        })
    }
}
