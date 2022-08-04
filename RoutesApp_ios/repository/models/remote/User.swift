//
//  User.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation

struct User: Codable, Equatable, BaseModel {
    var id: String
    let name: String
    let email: String
}
