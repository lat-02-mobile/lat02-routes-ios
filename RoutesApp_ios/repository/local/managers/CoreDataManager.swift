//
//  LocalManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case Failed(cause: String)
}

open class CoreDataManager {
    public static let name = ConstantVariables.databaseName
    public init() {}
    static var shared = CoreDataManager()
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataManager.name)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func getData<T: NSManagedObject>(entity: String) -> [T] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: entity)
        do {
            let dbWEntries = try context.fetch(fetchRequest)
            return dbWEntries
        } catch let error {
            print(error)
        }
        return []
    }

    func getData<T: NSManagedObject>(type: T.Type, entity: String, completion: @escaping(Result<[T], Error>) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: entity)
        do {
            let dbWEntries = try context.fetch(fetchRequest)
            completion(.success(dbWEntries))
        } catch let error {
            completion(.failure(error))
        }
    }

    func deleteEntityObjectByKeyValue<T>(entityName: T.Type, key: String, value: Any) -> Bool {
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entityName.self))
        if  let sValue = value as? String {
            let predicate = NSPredicate(format: "\(key) == %@", sValue)
            fetchRequest.predicate = predicate
        } else if let iValue = value as? Int64 {
            let predicate = NSPredicate(format: "\(key) == %d", iValue)
            fetchRequest.predicate = predicate
        }
        do {
            let result = try context.fetch(fetchRequest)
            if !result.isEmpty {
                if let managedObject = result[0] as? NSManagedObject {
                    context.delete(managedObject)
                    do {
                        self.saveContext()
                        return true
                    }
                }
            }
            return false
        } catch let error {
            print(error.localizedDescription)
        }
        return false
    }

    @discardableResult
    func deleteAll() -> Bool {
        let context = self.getContext()
        let deleteFavorites = NSBatchDeleteRequest(fetchRequest: FavoriteDest.fetchRequest())
        let deleteCategoryLines = NSBatchDeleteRequest(fetchRequest: LineCategoryEntity.fetchRequest())
        let deleteTourpointCategories = NSBatchDeleteRequest(fetchRequest: TourpointCategoryEntity.fetchRequest())
        do {
            try context.execute(deleteFavorites)
            try context.execute(deleteCategoryLines)
            try context.execute(deleteTourpointCategories)
            return true
        } catch {
            print("cant clean coredata")
            return false
        }
    }
}
