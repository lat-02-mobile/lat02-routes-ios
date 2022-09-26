//
//  AlgorithmTests.swift
//  RoutesApp_iosTests
//
//  Created by user on 30/8/22.
//

import XCTest
@testable import RoutesApp_ios

class AlgorithmTests: XCTestCase {
    var line1: LineRoute?
    var line2: LineRoute?

    override func setUpWithError() throws {
        // MARK: Route 1
        let routePoints1 = TestResources.points1Array
        let stops1 = TestResources.stops1Array
        line1 = LineRoute(name: "01", id: "01", idLine: "Zy8i3x4nQH0os7TaCizc", line: "Lines/4MhlK4IGLhTL6wcf50xk",
            routePoints: routePoints1, start: routePoints1[0], stops: stops1, end: routePoints1[1], averageVelocity: 20.5)
        // MARK: Route 2
        let routePoints2 = TestResources.points2Array
        let stops2 = TestResources.stops2Array
        line2 = LineRoute(name: "1001", id: "01", idLine: "Zy8i3x4nQH0os7TaCizc", line: "Lines/4MhlK4IGLhTL6wcf50xk",
            routePoints: routePoints2, start: routePoints2[0], stops: stops2, end: routePoints2[1], averageVelocity: 30.2)
    }

    func testWhenGivenLinePassThroughOriginAndDestination() throws {
        let originPoint = Coordinate(latitude: -16.52111, longitude: -68.12385).toCLLocationCoordinate2D()
        let destinationPoint = Coordinate(latitude: -16.52227, longitude: -68.12197).toCLLocationCoordinate2D()
        let minDistance = 200.0
        let minDistanceBtwStops = 200.0

        guard let line1 = line1,
                let line2 = line2 else {
            XCTAssertTrue(false)
            return
        }

        let expectedLine = LineRoute(name: line1.name, id: line1.id, idLine: line1.idLine, line: line1.line,
                                     routePoints: Array(line1.routePoints[2...5]), start: line1.start, stops: Array(line1.stops[0...2]),
                                     end: line1.end, averageVelocity: line1.averageVelocity)
        let result = Algorithm.shared.findAvailableRoutes(origin: originPoint, destination: destinationPoint,
            lines: [line1, line2], minDistanceBtwPoints: minDistance, minDistanceBtwStops: minDistanceBtwStops)
        XCTAssertEqual(expectedLine, result[0].transports[0])
    }

    func testWhenGivenLinesNeedToCombineLines() throws {
        let originPoint = Coordinate(latitude: -16.52153, longitude: -68.12278).toCLLocationCoordinate2D()
        let destinationPoint = Coordinate(latitude: -16.52423, longitude: -68.1203).toCLLocationCoordinate2D()
        let minDistance = 200.0
        let minDistanceBtwStops = 200.0

        guard let line1 = line1,
                let line2 = line2 else {
            XCTAssertTrue(false)
            return
        }

        let expectedSubLineA = LineRoute(name: line1.name, id: line1.id, idLine: line1.idLine, line: line1.line,
                                         routePoints: Array(line1.routePoints[3...10]), start: line1.start,
                                         stops: Array(line1.stops[1...4]), end: line1.end, averageVelocity: line1.averageVelocity)

        let expectedSubLineB = LineRoute(name: line2.name, id: line2.id, idLine: line2.idLine, line: line2.line,
                                         routePoints: Array(line2.routePoints[5...8]), start: line2.start,
                                         stops: Array(line2.stops[1...2]), end: line2.end, averageVelocity: line2.averageVelocity)

        let expectedAvailableTransport = AvailableTransport(connectionPoint: 3,
                transports: [expectedSubLineA, expectedSubLineB])

        let result = Algorithm.shared.findAvailableRoutes(origin: originPoint, destination: destinationPoint,
            lines: [line1, line2], minDistanceBtwPoints: minDistance, minDistanceBtwStops: minDistanceBtwStops)
        XCTAssertEqual(expectedAvailableTransport, result[0])
    }

    func testWhenGivenLinesHasOneLineAndCombinedRoute() throws {
        let originPoint = Coordinate(latitude: -16.52153, longitude: -68.12278).toCLLocationCoordinate2D()
        let destinationPoint = Coordinate(latitude: -16.52445, longitude: -68.12298).toCLLocationCoordinate2D()
        let minDistance = 200.0
        let minDistanceBtwStops = 200.0

        guard let line1 = line1,
                let line2 = line2 else {
            XCTAssertTrue(false)
            return
        }

        let expectedSubLineA = LineRoute(name: line1.name, id: line1.id, idLine: line1.idLine, line: line1.line,
                                         routePoints: Array(line1.routePoints[3...10]), start: line1.start,
                                         stops: Array(line1.stops[2...4]), end: line1.end, averageVelocity: line1.averageVelocity)

        let expectedSubLineB = LineRoute(name: line2.name, id: line2.id, idLine: line2.idLine, line: line2.line,
                                            routePoints: [line2.routePoints[5]], start: line2.start, stops: [line2.stops[1]],
                                            end: line2.end, averageVelocity: line2.averageVelocity)

        let expectedCombinedAvailableTransport = AvailableTransport(connectionPoint: 3,
                transports: [expectedSubLineA, expectedSubLineB])

        let expectedOneLineAvailableTransport = AvailableTransport(connectionPoint: nil,
                transports: [expectedSubLineA])

        let result = Algorithm.shared.findAvailableRoutes(origin: originPoint, destination: destinationPoint,
            lines: [line1, line2], minDistanceBtwPoints: minDistance, minDistanceBtwStops: minDistanceBtwStops)

        XCTAssertEqual([expectedCombinedAvailableTransport, expectedOneLineAvailableTransport], result)
    }
}
