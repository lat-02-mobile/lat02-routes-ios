//
//  LineCategoryEntity+CoreDataProperties.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//
//

import Foundation
import CoreData

extension LineCategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LineCategoryEntity> {
        return NSFetchRequest<LineCategoryEntity>(entityName: self.name)
    }

    @NSManaged public var id: String
    @NSManaged public var nameEng: String
    @NSManaged public var nameEsp: String
    @NSManaged public var whiteIcon: String
    @NSManaged public var blackIcon: String
    @NSManaged public var createdAt: Date
}

extension LineCategoryEntity: Identifiable {

}
