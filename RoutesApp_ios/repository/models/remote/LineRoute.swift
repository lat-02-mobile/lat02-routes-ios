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
import CoreData

// Used in algorithm
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

    static func getWalkLineRoute(routePoints: [Coordinate]) -> LineRoute {
        return LineRoute(
            name: self.lineWalkName,
            id: "00000000000",
            idLine: "00000000000",
            line: self.lineWalkName,
            routePoints: routePoints,
            start: Coordinate(latitude: 0, longitude: 0),
            stops: [],
            end: Coordinate(latitude: 0, longitude: 0),
            averageVelocity: 87.1728,
            blackIcon: "",
            whiteIcon: "",
            color: "#67F5ED"
        )
    }

    static let lineWalkName = "Walk"

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

public struct Coordinate: Codable, Equatable {
    let latitude: Double
    let longitude: Double

    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func toNSCoordinates() -> NSCoordinates {
        return NSCoordinates(lat: latitude, lon: longitude)
    }

    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct LinesCandidate: Codable {
    var originList: [LineRoute]
    var destinationList: [LineRoute]
}

// Used for obtain the Firestore response (LineRoute entity)
struct LineRouteInfo: Codable, Equatable {
    let name: String
    let id: String
    let idLine: String
    let line: DocumentReference?
    let routePoints: [GeoPoint]
    let start: GeoPoint
    let stops: [GeoPoint]
    let end: GeoPoint
    let averageVelocity: String
    let color: String

    static private let lineCatManager = LineCategoryFirebaseManager.shared
    static private let lineManager = LineFirebaseManager.shared

    func toLineRoute() async throws -> LineRoute {
        let line = try await LineRouteInfo.lineManager.getLineByIdAsync(lineId: idLine)
        let lineCategory = try await LineRouteInfo.lineCatManager.getLineCategoryByIdAsync(lineId: line.idCategory)
        let startAsCoordinate = Coordinate(latitude: self.start.latitude, longitude: self.start.longitude)
        let endAsCoordinate = Coordinate(latitude: self.end.latitude, longitude: self.end.longitude)
        var lineRoutePointsAsCoordinates = [Coordinate]()
        self.routePoints.forEach { routePoint in
            lineRoutePointsAsCoordinates.append(Coordinate(latitude: routePoint.latitude,
                                                           longitude: routePoint.longitude))
        }

        var lineRouteStopsAsCoordinates = [Coordinate]()
        self.stops.forEach { stop in
            lineRouteStopsAsCoordinates.append(Coordinate(latitude: stop.latitude,
                                                          longitude: stop.longitude))
        }

        let lineRoute = LineRoute(name: self.name,
                                  id: self.id,
                                  idLine: self.idLine,
                                  line: line.name,
                                  routePoints: lineRoutePointsAsCoordinates,
                                  start: startAsCoordinate,
                                  stops: lineRouteStopsAsCoordinates,
                                  end: endAsCoordinate,
                                  averageVelocity: Double(self.averageVelocity)!,
                                  blackIcon: lineCategory.blackIcon,
                                  whiteIcon: lineCategory.whiteIcon,
                                  color: self.color)
        return lineRoute
    }

    func convertToLinePath() -> LinePath {
        let start = Coordinate(latitude: start.latitude, longitude: start.longitude)
        let end = Coordinate(latitude: end.latitude, longitude: end.longitude)
        var routePointsArray = [Coordinate]()
        var stopsArray = [Coordinate]()
        for line in routePoints {
            let coordinate = Coordinate(latitude: line.latitude, longitude: line.longitude)
            routePointsArray.append(coordinate)
        }
        for stop in stops {
            let coordinate = Coordinate(latitude: stop.latitude, longitude: stop.longitude)
            stopsArray.append(coordinate)
        }
        let linePath = LinePath(name: name, id: id, idLine: idLine,
                                line: line, routePoints: routePointsArray, start: start, end: end, stops: stopsArray)
        return linePath
    }
}

// Used in RouteMap
struct LinePath: Codable, Equatable {
    let name: String
    let id: String
    let idLine: String
    let line: DocumentReference?
    let routePoints: [Coordinate]
    let start: Coordinate
    let end: Coordinate
    let stops: [Coordinate]

    func toEntity(context: NSManagedObjectContext) -> LineRouteEntity {
        let entity = LineRouteEntity(context: context)
        entity.name = name
        entity.id = id
        entity.idLine = idLine
        entity.routePoints = routePoints
        entity.start = start.toNSCoordinates()
        entity.end = end.toNSCoordinates()
        entity.stops = stops
        entity.createdAt = Date()
        return entity
    }
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
