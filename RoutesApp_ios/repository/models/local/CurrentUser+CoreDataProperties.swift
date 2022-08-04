//
//  CurrentUser+CoreDataProperties.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 3/8/22.
//
//

import Foundation
import CoreData

extension CurrentUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentUser> {
        return NSFetchRequest<CurrentUser>(entityName: "CurrentUser")
    }

    @NSManaged public var id: String?

}

extension CurrentUser: Identifiable {

}
