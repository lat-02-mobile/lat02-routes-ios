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
    static let testPhoneNumber = "+523353658071"
    static let testCode = "0626"
    static let verificationId = "eyJ0eXAioiJkv1QiLcJhbgCi0iJIUzJkv1QiXAio"
}
