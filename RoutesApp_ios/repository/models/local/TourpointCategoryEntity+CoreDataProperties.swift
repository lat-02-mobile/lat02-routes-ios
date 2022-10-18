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
}

extension TourpointCategoryEntity: Identifiable {

}
