//
//  FavoriteDest+CoreDataProperties.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 20/9/22.
//
//

import Foundation
import CoreData

extension FavoriteDest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteDest> {
        return NSFetchRequest<FavoriteDest>(entityName: "FavoriteDest")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: Int64
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?
    @NSManaged public var idCity: String?
    @NSManaged public var idUser: String?

}

extension FavoriteDest: Identifiable {

}
