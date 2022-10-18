//
//  LineEntity+CoreDataProperties.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//
//

import Foundation
import CoreData

extension LineEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LineEntity> {
        return NSFetchRequest<LineEntity>(entityName: self.name)
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var idCategory: String
    @NSManaged public var createdAt: Date
    @NSManaged public var routesSet: NSSet
    @NSManaged public var category: LineCategoryEntity

    public var routes: [LineRouteEntity] {
        let set = routesSet as? Set<LineRouteEntity> ?? []
        return set.map({$0})
    }

}

// MARK: Generated accessors for routes
extension LineEntity {

    @objc(addRoutesObject:)
    @NSManaged public func addToRoutes(_ value: LineRouteEntity)

    @objc(removeRoutesObject:)
    @NSManaged public func removeFromRoutes(_ value: LineRouteEntity)

    @objc(addRoutes:)
    @NSManaged public func addToRoutes(_ values: NSSet)

    @objc(removeRoutes:)
    @NSManaged public func removeFromRoutes(_ values: NSSet)

}

extension LineEntity: Identifiable {

}
