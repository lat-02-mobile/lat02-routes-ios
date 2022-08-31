//
//  CityRoute.swift
//  RoutesApp_ios
//
//  Created by user on 29/8/22.
//

import Foundation
import CoreLocation

struct CityRoute: Codable {
    let id: String
    let name: String
    let transportationMethods: [TrasportationMethod]
}

struct TrasportationMethod: Codable {
    let name: String
    let lines: [Route]
}

struct Route: Codable, Equatable {
    let name: String
    let routePoints: [Coordinate]
    let start: Coordinate
    let stops: [Coordinate]

    static func == (lhs: Route, rhs: Route) -> Bool {
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
    var originList: [TransportationWithLines]
    var destinationList: [TransportationWithLines]
}

struct TransportationWithLines: Codable, Equatable {
    let name: String
    let line: Route

    static func == (lhs: TransportationWithLines, rhs: TransportationWithLines) -> Bool {
        return lhs.name == rhs.name && lhs.line == rhs.line
    }
}

struct AvailableTransport {
    var connectionPoint: Int?
    var transports: [TransportationWithLines] = []
}
