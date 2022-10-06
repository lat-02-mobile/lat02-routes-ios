//
//  TourpointEntity+CoreDataProperties.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//
//

import Foundation
import CoreData

extension TourpointEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TourpointEntity> {
        return NSFetchRequest<TourpointEntity>(entityName: self.name)
    }

    @NSManaged public var name: String
    @NSManaged public var address: String
    @NSManaged public var urlImage: String
    @NSManaged public var destination: NSCoordinates
    @NSManaged public var createdAt: Date
    @NSManaged public var category: String
}

extension TourpointEntity: Identifiable {

}
