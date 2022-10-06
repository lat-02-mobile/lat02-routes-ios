//
//  Tourpoint.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/28/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import CoreData

struct Tourpoint: Codable {
    var address: String
    var categoryId: String
    var destination: GeoPoint
    var idCity: DocumentReference?
    var name: String
    var tourPointsCategoryRef: DocumentReference?
    var urlImage: String

    func toTourpointInfo(categories: [TourpointCategory], isLocationEng: Bool) -> TourpointInfo {
        let categoryFirst = categories.first(where: {$0.id == categoryId})
        guard let category = categoryFirst else { return TourpointInfo()}
        let categoryStr = isLocationEng ? category.descriptionEng : category.descriptionEsp
        return TourpointInfo(address: address, destination: destination.toCoordinate(), name: name, category: categoryStr, urlImage: urlImage)
    }

}

struct TourpointInfo {
    var address: String = ""
    var destination: Coordinate = Coordinate(latitude: 0, longitude: 0)
    var name: String = ""
    var category: String = ""
    var urlImage: String = ""

    func toEntity(context: NSManagedObjectContext) {
        let entity = TourpointEntity(context: context)
        entity.address = address
        entity.destination = destination.toNSCoordinates()
        entity.name = name
        entity.category = category
        entity.urlImage = urlImage
        entity.createdAt = Date()
    }
}

struct TourpointCategory: Codable, BaseModel {
    var id: String
    var descriptionEng: String
    var descriptionEsp: String

    func toEntity(context: NSManagedObjectContext) {
        let entity = TourpointCategoryEntity(context: context)
        entity.createdAt = Date()
        entity.descriptionEng = descriptionEng
        entity.descriptionEsp = descriptionEsp
        entity.id = id
    }
}
