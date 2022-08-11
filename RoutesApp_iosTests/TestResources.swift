//
//  TestResources.swift
//  RoutesApp_iosTests
//
//  Created by Alvaro Choque on 9/8/22.
//

import Foundation
@testable import RoutesApp_ios

class TestResources {
    static let testUserEmail = "john@doe.com"
    static let testUserPassword = "test1234"
    static let testAuthResponse = ["message": "success"]
    static let testUser = User(id: "test", name: "test", email: "test@email.com", phoneNumber: "test", type: 0, typeLogin: 0, updatedAt: Date(), createdAt: Date())
    static let testGoogleUser = User(id: "test", name: "test", email: "test@email.com",
         phoneNumber: "test", type: 0, typeLogin: 3, updatedAt: Date(), createdAt: Date())
}
