//
//  Country.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import Foundation
import FirebaseFirestore

struct Country: Codable, Equatable, BaseModel {
    var id: String
    var name: String
    var code: String
    var phone: String
    var createdAt: Date
    var updatedAt: Date
    var cities: String
}
