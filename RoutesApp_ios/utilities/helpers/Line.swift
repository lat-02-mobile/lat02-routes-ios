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

    // Returns a new line from the start till the given coordinate
    func slice(till coordinate: Coordinate) -> Line {
        let indexOfCoordinatePoint = getIndexWhere(coordinate: coordinate, coordinateList: routePoints)
        let indexOfCoordinateStop = getIndexWhere(coordinate: coordinate, coordinateList: stops)
        let routePoints = Array(routePoints[0...indexOfCoordinatePoint])
        let stops = Array(stops[0...indexOfCoordinateStop])
        return Line(name: name,
            categoryRef: categoryRef, routePoints: routePoints,
            start: start, stops: stops)
    }

    // Returns a new line from the given coordinate till the end
    func slice(from coordinate: Coordinate) -> Line {
        let indexOfCoordinatePoint = getIndexWhere(coordinate: coordinate, coordinateList: routePoints)
        let indexOfCoordinateStop = getIndexWhere(coordinate: coordinate, coordinateList: stops)
        let routePoints = Array(routePoints[indexOfCoordinatePoint...])
        let stops = Array(stops[indexOfCoordinateStop...])
        return Line(name: name,
             categoryRef: categoryRef, routePoints: routePoints,
             start: start, stops: stops)
    }

    // Returns a new line from-till
    func slice(from coordinateFrom: Coordinate, till coordinateTill: Coordinate) -> Line {
        // MARK: Stops indexes from till
        let indexStopOrigin = getIndexWhere(coordinate: coordinateFrom, coordinateList: stops)
        let indexStopDestination = getIndexWhere(coordinate: coordinateTill, coordinateList: stops)
        // MARK: New Stops
        let newStops = Array(stops[indexStopOrigin...indexStopDestination])

        // MARK: RoutePoints indexes from till
        let indexOriginPoint = getIndexWhere(coordinate: coordinateFrom, coordinateList: routePoints)
        let indexDestinationPoint = getIndexWhere(coordinate: coordinateTill, coordinateList: routePoints)
        // MARK: New RoutePoints
        let newRoutePoints = Array(routePoints[indexOriginPoint...indexDestinationPoint])

        return Line(name: name, categoryRef: categoryRef, routePoints: newRoutePoints, start: start, stops: newStops)
    }

    private func getIndexWhere(coordinate: Coordinate, coordinateList: [Coordinate]) -> Int {
        return coordinateList.firstIndex(where: { $0 == coordinate }) ?? -1
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
