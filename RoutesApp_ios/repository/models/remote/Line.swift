//
//  CityRoute.swift
//  RoutesApp_ios
//
//  Created by user on 29/8/22.
//

import Foundation
import CoreLocation
import CodableFirebase
import Firebase

struct LineRoute: Codable, Equatable {
    let name: String
    let id: String
    let idLine: String
    let line: String
    let routePoints: [Coordinate]
    let start: Coordinate
    let stops: [Coordinate]
    let end: Coordinate
    // Average velocity in meters per second
    var averageVelocity: Double
    let blackIcon: String
    let whiteIcon: String
    let color: String

    static func == (lhs: LineRoute, rhs: LineRoute) -> Bool {
        return lhs.name == rhs.name
    }

    // Returns a new line from the start till the given coordinate
    func slice(till coordinate: Coordinate) -> LineRoute {
        let indexOfCoordinatePoint = getIndexWhere(coordinate: coordinate, coordinateList: routePoints)
        let indexOfCoordinateStop = getIndexWhere(coordinate: coordinate, coordinateList: stops)
        let routePoints = Array(routePoints[0...indexOfCoordinatePoint])
        let stops = Array(stops[0...indexOfCoordinateStop])
        return LineRoute(name: name, id: id, idLine: idLine, line: line, routePoints: routePoints,
                         start: start, stops: stops, end: end, averageVelocity: averageVelocity,
                         blackIcon: blackIcon, whiteIcon: whiteIcon, color: color)
    }

    // Returns a new line from the given coordinate till the end
    func slice(from coordinate: Coordinate) -> LineRoute {
        let indexOfCoordinatePoint = getIndexWhere(coordinate: coordinate, coordinateList: routePoints)
        let indexOfCoordinateStop = getIndexWhere(coordinate: coordinate, coordinateList: stops)
        let routePoints = Array(routePoints[indexOfCoordinatePoint...])
        let stops = Array(stops[indexOfCoordinateStop...])
        return LineRoute(name: name, id: id, idLine: idLine, line: line,
                         routePoints: routePoints, start: start, stops: stops, end: end, averageVelocity: averageVelocity,
                         blackIcon: blackIcon, whiteIcon: whiteIcon, color: color)
    }

    // Returns a new line from-till
    func slice(from coordinateFrom: Coordinate, till coordinateTill: Coordinate) -> LineRoute {
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

        return LineRoute(name: name, id: id, idLine: idLine, line: line,
            routePoints: newRoutePoints, start: start, stops: newStops, end: end,
            averageVelocity: averageVelocity, blackIcon: blackIcon, whiteIcon: whiteIcon, color: color)
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
    var originList: [LineRoute]
    var destinationList: [LineRoute]
}

struct Line: Codable, Equatable {
    let categoryRef: DocumentReference
    let enable: Bool
    let id: String
    let idCategory: String
    let idCity: String
    let name: String
    let routePath: [LineRoute]
}

// Used in RouteMap
struct LinePath: Codable, Equatable {
    let name: String
    let idCategory: String
    let enable: Bool
    let routePoints: [Coordinate]
    let start: Coordinate
    let end: Coordinate
    let stops: [Coordinate]
}

// What the algorithm returns
struct AvailableTransport: Equatable {
    var connectionPoint: Int?
    var transports: [LineRoute] = []

    static func == (lhs: AvailableTransport, rhs: AvailableTransport) -> Bool {
        return lhs.connectionPoint == rhs.connectionPoint && lhs.transports == rhs.transports
    }

    func calculateEstimatedTimeToArrive() -> Int {
        var totalMins = 0
        for line in transports {
            totalMins += Int(GoogleMapsHelper.shared.getEstimatedTimeToArrive(averageVelocityMeterSec: line.averageVelocity,
             totalDistanceMeters: Double(calculateTotalDistance())))
        }
        return totalMins
    }

    func calculateTotalDistance() -> Int {
        var totalDistance = 0
        for line in transports {
            totalDistance += Int(GoogleMapsHelper.shared.getTotalPolylineDistance(coordList: line.routePoints))
        }
        return totalDistance
    }
}
