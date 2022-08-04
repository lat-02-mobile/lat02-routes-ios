//
//  LocalManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation
import CoreData

class CoreDataManager {
    static var shared = CoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RoutesApp_ios")
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
    func getData<T: NSManagedObject>() -> [T] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: "CurrentUser")
        do {
            let dbWEntries = try context.fetch(fetchRequest)
            return dbWEntries
        } catch {
            return []
        }
    }
    func deleteElement<T: NSManagedObject>(element: T) {
        let context = persistentContainer.viewContext
        context.delete(element)
        try? context.save()
    }
    @discardableResult
    func deleteAll() -> Bool {
        let context = self.getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: CurrentUser.fetchRequest())
        do {
            try context.execute(delete)
        } catch {
            return false
        }
        return true
    }
    func saveCurrentUser(idUser: String) {
        let context = self.getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "CurrentUser", in: context) else {return}
        guard let entry = NSManagedObject(entity: entity, insertInto: context) as? CurrentUser else {return}
        entry.id = idUser
        try? context.save()
    }
}
