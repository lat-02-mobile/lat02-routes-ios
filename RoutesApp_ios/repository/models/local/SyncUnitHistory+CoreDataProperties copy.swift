//
//  SyncUnitHistory+CoreDataProperties.swift
//  
//
//  Created by admin on 10/20/22.
//
//

import Foundation
import CoreData

extension SyncUnitHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SyncUnitHistory> {
        return NSFetchRequest<SyncUnitHistory>(entityName: "SyncUnitHistory")
    }

    @NSManaged public var id: String?
    @NSManaged public var lastUpdated: Date?

}
