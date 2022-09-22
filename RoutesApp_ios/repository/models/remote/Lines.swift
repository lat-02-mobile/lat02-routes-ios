//
//  Line.swift
//  RoutesApp_ios
//
//  Created by admin on 9/5/22.
//

import Foundation
import CodableFirebase
import Firebase

extension GeoPoint: GeoPointType {}

struct RouteListDetailModel {
    let idCity: String?
    let name: String?
    let routePoints: [GeoPoint]?
    let line: String?
    let start: GeoPoint?
    let end: GeoPoint?
    let nameEng: String?
    let nameEsp: String?
    let category: LinesCategory
}

struct Lines: Codable {
    let categoryRef: DocumentReference?
    let idCity: String?
    let idCategory: String?
    let name: String?
    let routePoints: [GeoPoint]?
    let start: GeoPoint?
    let end: GeoPoint?
    let stops: [GeoPoint]?
}

struct LinesCategory: Codable {
    let id: String?
    let nameEng: String?
    let nameEsp: String?
}
