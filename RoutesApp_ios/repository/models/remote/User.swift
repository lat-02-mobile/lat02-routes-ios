//
//  User.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Equatable, BaseModel {
    var id: String
    var name: String
    var email: String
    var phoneNumber: String
    var type: Int
    var typeLogin: Int
    var updateAt: Timestamp
    var createAt: Timestamp
}

struct UserFirebase: Codable, Equatable, BaseModel {
    var id: String
    var name: String
    var email: String
    var phoneNumber: String
    var type: Int
    var typeLogin: Int
    var updateAt: Timestamp
    var createAt: Timestamp
}
