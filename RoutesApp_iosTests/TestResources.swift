//
//  TestResources.swift
//  RoutesApp_iosTests
//
//  Created by Alvaro Choque on 9/8/22.
//

import Foundation
@testable import Firebase
@testable import FirebaseFirestoreSwift
@testable import RoutesApp_ios
@testable import FirebaseFirestore
import CoreLocation
@testable import GooglePlaces

class TestResources {
    static let testUserEmail = "john@doe.com"
    static let testUserPassword = "test1234"
    static let testAuthResponse = ["message": "success"]
    static let testUser = User(id: "test", name: "test", email: "test@email.com", phoneNumber: "test", type: 0, typeLogin: 0, updatedAt: Date(), createdAt: Date())
    static let testUserFirebase1 = UserFirebase(id: "test1", name: "test1", email: "email111@email.com", phoneNumber: "test",
                                                type: UserType.NORMAL.rawValue, typeLogin: UserTypeLogin.NORMAL.rawValue,
                                                updatedAt: 687626719.592621, createdAt: 687626719.592621)
    static let testUserFirebase2 = UserFirebase(id: "test2", name: "test2", email: "email222@email.com", phoneNumber: "test",
                                                type: UserType.ADMIN.rawValue, typeLogin: UserTypeLogin.NORMAL.rawValue,
                                                updatedAt: 687626719.592621, createdAt: 687626719.592621)
    static let testUserFirebase3 = UserFirebase(id: "test3", name: "test3", email: "email333@email.com", phoneNumber: "test",
                                                type: UserType.NORMAL.rawValue, typeLogin: UserTypeLogin.NORMAL.rawValue,
                                                updatedAt: 687626719.592621, createdAt: 687626719.592621)

    static let testUserFirebaseList = [testUserFirebase1, testUserFirebase2, testUserFirebase3]

    static let testPhoneNumber = "+523353658071"
    static let testCode = "0626"
    static let verificationId = "eyJ0eXAioiJkv1QiLcJhbgCi0iJIUzJkv1QiXAio"

    static let lineCategoryEntity: [LineCategoryEntity] = []
    static let lineEntity: [LineEntity] = []
    static let lineRouteEntity: [LineRouteEntity] = []
    static let tourpointCategoryEntity: [TourpointCategoryEntity] = []
    static let tourpointEntity: [TourpointEntity] = []

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

    static let points3Array = [
        Coordinate(latitude: -16.52154, longitude: -68.12311),
        Coordinate(latitude: -16.52231, longitude: -68.12344),
        Coordinate(latitude: -16.52236, longitude: -68.12433),
        Coordinate(latitude: -16.52271, longitude: -68.1254),
        Coordinate(latitude: -16.52353, longitude: -68.12601),
        Coordinate(latitude: -16.52419, longitude: -68.12609)
     ]

    static let stops3Array = [
        Coordinate(latitude: -16.52154, longitude: -68.12311),
        Coordinate(latitude: -16.52236, longitude: -68.12433),
        Coordinate(latitude: -16.52419, longitude: -68.12609)
     ]

    static let timestamp = Timestamp()
    static let testCityRouteName = "testCity"
    static let testCountryId = "testCountry"
    static let testCityRoute = Cities(country: "test", id: "testid", idCountry: "countryTest", lat: "-35", lng: "-17", name: "testCity")
    static let testCountry = Country(
        id: "test", name: "testCountry", code: "test", phone: "test", createdAt: nil, updatedAt: nil, cities: [DocumentReference]()
    )

    static let findPlacesTest = Place(name: "A place name", identifier: "123456")
    static let queryToSendTest = "place"
    static let placeBiasTest = GMSPlaceRectangularLocationOption(CLLocationCoordinate2D(), CLLocationCoordinate2D())

    static let lines = [
        Lines(categoryRef: nil, enable: true, id: "1", idCity: "1", idCategory: "1", name: "Line E", updateAt: timestamp, createAt: timestamp),
        Lines(categoryRef: nil, enable: true, id: "2", idCity: "1", idCategory: "2", name: "Line 5", updateAt: timestamp, createAt: timestamp),
        Lines(categoryRef: nil, enable: true, id: "3", idCity: "1", idCategory: "2", name: "Line 72", updateAt: timestamp, createAt: timestamp)
    ]

    static let lineCategories = [
        LinesCategory(id: "1", nameEng: "Subway", nameEsp: "Subway", blackIcon: "", whiteIcon: "", updateAt: timestamp, createAt: timestamp),
        LinesCategory(id: "2", nameEng: "Bus", nameEsp: "Bus", blackIcon: "", whiteIcon: "", updateAt: timestamp, createAt: timestamp)
    ]

    static let tourpoints = [
        Tourpoint(address: "Address 1", categoryId: "123456", destination: GeoPoint(latitude: 0, longitude: 0), idCity: nil,
                  name: "Line Name", tourPointsCategoryRef: nil, urlImage: "URL image", updateAt: timestamp, createAt: timestamp, id: "dedeqdfefr")
    ]

    static let tourpointCategories = [
        TourpointCategory(id: "123456", descriptionEng: "ENG", descriptionEsp: "ESP", icon: "new Icon url", updateAt: timestamp, createAt: timestamp)
    ]

    static let RoutePoints = [GeoPoint(latitude: 1, longitude: 1), GeoPoint(latitude: 1, longitude: 1)]
    static let Stops = [GeoPoint(latitude: 1, longitude: 1), GeoPoint(latitude: 1, longitude: 1)]

    static let LineRoutes = [
        LineRouteInfo(name: "Route1", id: "wsws2344d3f", idLine: "1",
                      line: nil, routePoints: RoutePoints, start: GeoPoint(latitude: 1, longitude: 1),
                      stops: Stops, end: GeoPoint(latitude: 1, longitude: 1),
                      averageVelocity: "", color: "", updateAt: timestamp, createAt: timestamp),
        LineRouteInfo(name: "Route1", id: "wsws2344d3f", idLine: "1",
                      line: nil, routePoints: RoutePoints, start: GeoPoint(latitude: 1, longitude: 1),
                      stops: Stops, end: GeoPoint(latitude: 1, longitude: 1),
                      averageVelocity: "", color: "", updateAt: timestamp, createAt: timestamp)
   ]

    // For LineTests
    static let Line1 = Lines(categoryRef: FirebaseFirestoreManager.shared.getDocReference(forCollection: .Lines, documentID: "111"),
                             enable: false,
                             id: "111",
                             idCity: "111",
                             idCategory: "222",
                             name: "Line1",
                             updateAt: timestamp,
                             createAt: timestamp)

    static let Line2 = Lines(categoryRef: FirebaseFirestoreManager.shared.getDocReference(forCollection: .Lines, documentID: "222"),
                             enable: false,
                             id: "222",
                             idCity: "222",
                             idCategory: "333",
                             name: "Line2",
                             updateAt: timestamp,
                             createAt: timestamp)

    static let LinesArray = [Line1, Line2]

    static let CitiesArray = [Cities(country: "Bolivia", id: "111", idCountry: "121", lat: "0.0", lng: "0.0", name: "city1"),
                              Cities(country: "Mexico", id: "222", idCountry: "222", lat: "0.0", lng: "0.0", name: "city2"),
                              Cities(country: "Bolivia", id: "333", idCountry: "323", lat: "0.0", lng: "0.0", name: "city3")]

    static let DummyCoords = GeoPoint(latitude: 0.0, longitude: 0.0)
}
extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
