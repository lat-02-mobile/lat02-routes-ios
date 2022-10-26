//
//  TourpointCategoryEntity+CoreDataProperties.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//
//

import Foundation
import CoreData

extension TourpointCategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TourpointCategoryEntity> {
        return NSFetchRequest<TourpointCategoryEntity>(entityName: self.name)
    }

    @NSManaged public var id: String
    @NSManaged public var descriptionEng: String
    @NSManaged public var descriptionEsp: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updateAt: Date
    @NSManaged public var icon: String
    @NSManaged public var tourpoints: NSSet?

}

// MARK: Generated accessors for tourpoints
extension TourpointCategoryEntity {

    @objc(addTourpointsObject:)
    @NSManaged public func addToTourpoints(_ value: TourpointEntity)

    @objc(removeTourpointsObject:)
    @NSManaged public func removeFromTourpoints(_ value: TourpointEntity)

    @objc(addTourpoints:)
    @NSManaged public func addToTourpoints(_ values: NSSet)

    @objc(removeTourpoints:)
    @NSManaged public func removeFromTourpoints(_ values: NSSet)

}

extension TourpointCategoryEntity: Identifiable {

}
