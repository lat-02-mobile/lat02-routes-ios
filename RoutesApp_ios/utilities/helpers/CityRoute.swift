//
//  CityRoute.swift
//  RoutesApp_ios
//
//  Created by user on 29/8/22.
//

import Foundation
import CoreLocation
import Firebase

struct Line: Codable, Equatable {
    let name: String
    let categoryRef: String
    let routePoints: [Coordinate]
    let start: Coordinate
    let stops: [Coordinate]

    static func == (lhs: Line, rhs: Line) -> Bool {
        return lhs.name == rhs.name
    }
}

struct Coordinate: Codable, Equatable {
    let latitude: Double
    let longitude: Double

    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct LinesCandidate: Codable {
    var originList: [Line]
    var destinationList: [Line]
}

struct AvailableTransport {
    var connectionPoint: Int?
    var transports: [Line] = []
}
