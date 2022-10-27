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

struct Lines: Codable, BaseModel {
    let categoryRef: DocumentReference?
    let enable: Bool
    var id: String
    let idCity: String
    let idCategory: String
    let name: String
    let updateAt: Timestamp
    let createAt: Timestamp

    func toEntity(categories: [LineCategoryEntity], context: NSManagedObjectContext) -> LineEntity {
        let categoryFirst = categories.first(where: {$0.id == idCategory})
        let entity = LineEntity(context: context)
        entity.id = id
        entity.idCategory = idCategory
        entity.name = name
        entity.category = categoryFirst ?? LineCategoryEntity()
        entity.createAt = createAt.dateValue()
        entity.updateAt = updateAt.dateValue()
        return entity
    }

    func getCategory(completion: @escaping(DocumentSnapshot?, Error?) -> Void) {
        self.categoryRef?.getDocument(completion: completion)
    }
}
