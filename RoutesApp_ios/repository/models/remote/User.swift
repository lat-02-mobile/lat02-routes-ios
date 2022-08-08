//
//  User.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation

struct User: Codable, Equatable, BaseModel {
    var id: String
    var name: String
    var email: String
    var phoneNumber: String
    var type: Int
    var typeLogin: Int
    var updatedAt: Date
    var createdAt: Date
}
