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
        return NSFetchRequest<LineCategoryEntity>(entityName: "LineCategoryEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var nameEng: String?
    @NSManaged public var nameEsp: String?
    @NSManaged public var whiteIcon: String?
    @NSManaged public var blackIcon: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var lines: NSSet?

}

// MARK: Generated accessors for lines
extension LineCategoryEntity {

    @objc(addLinesObject:)
    @NSManaged public func addToLines(_ value: LineEntity)

    @objc(removeLinesObject:)
    @NSManaged public func removeFromLines(_ value: LineEntity)

    @objc(addLines:)
    @NSManaged public func addToLines(_ values: NSSet)

    @objc(removeLines:)
    @NSManaged public func removeFromLines(_ values: NSSet)

}

extension LineCategoryEntity: Identifiable {

}
