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
    @NSManaged public var strDestination: String
    @NSManaged public var createdAt: Date
    @NSManaged public var category: TourpointCategoryEntity

    public var destination: Coordinate {
        get {
            return (try? JSONDecoder().decode(Coordinate.self, from: Data(strDestination.utf8))) ?? Coordinate(latitude: 0, longitude: 0)
        }
        set {
           do {
               let destinationData = try JSONEncoder().encode(newValue)
               strDestination = String(data: destinationData, encoding: .utf8) ?? ""
           } catch { strDestination = "" }
        }
    }
}

extension TourpointEntity: Identifiable {

}
