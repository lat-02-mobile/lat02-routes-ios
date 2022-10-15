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
    func retrieveAllDataFromFirebase(completion: @escaping (Result<Void, Error>) -> Void) {
        if sendWithError {
            completion(.failure(NSError(domain: "Error", code: 0)))
        } else {
            dataHasBeenRetrieved = true
            completion(.success(()))
        }
    }

    func getDataFromCoreData<T: NSManagedObject>(type: T.Type, forEntity: String, completion: @escaping (Result<[T], Error>) -> Void) {
        switch type {
        case is LineEntity.Type:
            let lines: [T] = convertLineToEntity()
            completion(.success(lines))
        case is LineCategoryEntity.Type:
            let categories: [T] = convertLineCategoryToEntity()
            completion(.success(categories))
        default:
            completion(.success([]))
        }

    }

    private func convertLineToEntity<T>() -> [T] {
        return TestResources.lines.map({ line in
            let entity = LineEntity(context: context)
            entity.id = line.id
            entity.name = line.name
            entity.idCategory = line.idCategory
            entity.createdAt = Date()
            entity.category = LineCategoryEntity(context: context)
            // swiftlint:disable force_cast
            return entity as! T
        })
    }

    private func convertLineCategoryToEntity<T>() -> [T] {
        return TestResources.lineCategories.map({ category in
            let entity = LineCategoryEntity(context: context)
            entity.id = category.id
            entity.nameEng = category.id
            entity.nameEsp = category.id
            entity.whiteIcon = category.id
            entity.blackIcon = category.id
            entity.createdAt = Date()
            // swiftlint:disable force_cast
            return entity as! T
        })
    }
}
