//
//  Line.swift
//  RoutesApp_ios
//
//  Created by admin on 9/5/22.
//

import Foundation
import CodableFirebase
import Firebase
import CoreData

struct RouteListDetailModel {
    let id: String?
    let idCity: String?
    let name: String?
    let nameEng: String?
    let nameEsp: String?
    let category: LinesCategory
}

struct Lines: Codable {
    let categoryRef: DocumentReference?
    let enable: Bool
    let id: String
    let idCity: String
    let idCategory: String
    let name: String

    func toEntity(categories: [LinesCategory], isLocationEng: Bool, context: NSManagedObjectContext) -> LineEntity {
        let categoryFirst = categories.first(where: {$0.id == idCategory})
        let entity = LineEntity(context: context)
        let categoryStr = isLocationEng ? categoryFirst?.nameEng : categoryFirst?.nameEsp
        entity.id = id
        entity.idCategory = idCategory
        entity.name = name
        entity.category = categoryStr ?? ""
        entity.createdAt = Date()
        return entity
    }
}

struct LinesCategory: Codable {
    let id: String
    let nameEng: String
    let nameEsp: String
    let blackIcon: String
    let whiteIcon: String

    func toEntity(context: NSManagedObjectContext) {
        let entity = LineCategoryEntity(context: context)
        entity.id = id
        entity.nameEng = nameEng
        entity.nameEsp = nameEsp
        entity.blackIcon = blackIcon
        entity.whiteIcon = whiteIcon
        entity.createdAt = Date()
    }
}
