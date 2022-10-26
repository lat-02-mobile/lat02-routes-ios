//
//  LineCategory.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 3/10/22.
//

import Foundation
import CoreData
import CodableFirebase
import Firebase

struct LinesCategory: Codable {
    let id: String
    let nameEng: String
    let nameEsp: String
    let blackIcon: String
    let whiteIcon: String
    let updateAt: Timestamp
    let createAt: Timestamp

    func toEntity(context: NSManagedObjectContext) -> LineCategoryEntity {
        let entity = LineCategoryEntity(context: context)
        entity.id = id
        entity.nameEng = nameEng
        entity.nameEsp = nameEsp
        entity.blackIcon = blackIcon
        entity.whiteIcon = whiteIcon
        entity.createAt = createAt.dateValue()
        entity.updateAt = updateAt.dateValue()
        return entity
    }
}
