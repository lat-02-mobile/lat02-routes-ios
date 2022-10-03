//
//  LineRouteEntity+CoreDataProperties.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//
//

import Foundation
import CoreData

extension LineRouteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LineRouteEntity> {
        return NSFetchRequest<LineRouteEntity>(entityName: "LineRouteEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var idLine: String?
    @NSManaged public var name: String?
    @NSManaged public var start: NSCoordinates?
    @NSManaged public var end: NSCoordinates?
    @NSManaged public var createdAt: Date?
    @NSManaged public var routePoints: NSSet?
    @NSManaged public var line: LineEntity?

}

// MARK: Generated accessors for routePoints
extension LineRouteEntity {

    @objc(addRoutePointsObject:)
    @NSManaged public func addToRoutePoints(_ value: PointHolder)

    @objc(removeRoutePointsObject:)
    @NSManaged public func removeFromRoutePoints(_ value: PointHolder)

    @objc(addRoutePoints:)
    @NSManaged public func addToRoutePoints(_ values: NSSet)

    @objc(removeRoutePoints:)
    @NSManaged public func removeFromRoutePoints(_ values: NSSet)

}

extension LineRouteEntity: Identifiable {

}
