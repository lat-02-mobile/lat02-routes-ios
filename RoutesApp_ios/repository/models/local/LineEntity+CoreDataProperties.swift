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
        return NSFetchRequest<LineEntity>(entityName: "LineEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var enable: Bool
    @NSManaged public var name: String?
    @NSManaged public var idCategory: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var category: LineCategoryEntity?
    @NSManaged public var routes: NSSet?

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
