//
//  LineCategory.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 3/10/22.
//

import Foundation
import CoreData

struct LinesCategory: Codable {
    let id: String
    let nameEng: String
    let nameEsp: String
    let blackIcon: String
    let whiteIcon: String

    func toEntity(context: NSManagedObjectContext) -> LineCategoryEntity {
        let entity = LineCategoryEntity(context: context)
        entity.id = id
        entity.nameEng = nameEng
        entity.nameEsp = nameEsp
        entity.blackIcon = blackIcon
        entity.whiteIcon = whiteIcon
        entity.createdAt = Date()
        return entity
    }
}
