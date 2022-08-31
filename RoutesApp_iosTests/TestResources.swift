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

    static let stops1Array = [
        Coordinate(latitude: -16.52130602845841, longitude: -68.12417648825397),
        Coordinate(latitude: -16.521670987319112, longitude: -68.12320625310048),
        Coordinate(latitude: -16.522451435494332, longitude: -68.12218135682076),
        Coordinate(latitude: -16.523780248849537, longitude: -68.12235510114752),
        Coordinate(latitude: -16.524285569842718, longitude: -68.12298370418992)
     ]

    static let points1Array = [
        Coordinate(latitude: -16.520939322501413, longitude: -68.12557074070023),
        Coordinate(latitude: -16.521062847351256, longitude: -68.12514516472181),
        Coordinate(latitude: -16.52130602845841, longitude: -68.12417648825397),
        Coordinate(latitude: -16.521670987319112, longitude: -68.12320625310048),
        Coordinate(latitude: -16.52197231180913, longitude: -68.12260107624422),
        Coordinate(latitude: -16.522451435494332, longitude: -68.12218135682076),
        Coordinate(latitude: -16.523261825566387, longitude: -68.12214426533951),
        Coordinate(latitude: -16.523703514803486, longitude: -68.1221403609752),
        Coordinate(latitude: -16.523780248849537, longitude: -68.12235510114752),
        Coordinate(latitude: -16.524002964559173, longitude: -68.12266159393164),
        Coordinate(latitude: -16.524285569842718, longitude: -68.12298370418992)
     ]

    static let points2Array = [
        Coordinate(latitude: -16.5255314, longitude: -68.1254204),
        Coordinate(latitude: -16.5247497, longitude: -68.1251629),
        Coordinate(latitude: -16.5247755, longitude: -68.1246533),
        Coordinate(latitude: -16.5251612, longitude: -68.1243314),
        Coordinate(latitude: -16.5251046, longitude: -68.1238218),
        Coordinate(latitude: -16.5246006, longitude: -68.1232156),
        Coordinate(latitude: -16.5245543, longitude: -68.1218155),
        Coordinate(latitude: -16.5247286, longitude: -68.1216115),
        Coordinate(latitude: -16.5241937, longitude: -68.1204527)
     ]

    static let stops2Array = [
        Coordinate(latitude: -16.5255314, longitude: -68.1254204),
        Coordinate(latitude: -16.5246006, longitude: -68.1232156),
        Coordinate(latitude: -16.5241937, longitude: -68.1204527)
     ]
}
