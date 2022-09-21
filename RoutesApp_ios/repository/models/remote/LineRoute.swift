//
//  LineRoute.swift
//  RoutesApp_ios
//
//  Created by admin on 9/21/22.
//

import Foundation
import CodableFirebase
import Firebase

extension GeoPoint: GeoPointType {}

struct LineRoute: Codable {
    let id: String?
    let idLine: String?
    let line: DocumentReference
    let name: String?
    let routePoints: [GeoPoint]?
    let start: GeoPoint?
    let end: GeoPoint?
    let stops: [GeoPoint]?
}
