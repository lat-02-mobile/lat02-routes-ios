//
//  AlgorithmTests.swift
//  RoutesApp_iosTests
//
//  Created by user on 30/8/22.
//

import XCTest
@testable import RoutesApp_ios

class AlgorithmTests: XCTestCase {
    var line1: Line?
    var line2: Line?

    override func setUpWithError() throws {
        // MARK: Route 1
        let routePoints1 = TestResources.points1Array
        let stops1 = TestResources.stops1Array
        line1 = Line(name: "01", categoryRef: "LineCategories/DW8blCpvs0OXwkozaEhn",
                     routePoints: routePoints1, start: routePoints1[0], stops: stops1, averageVelocity: 20.5)
        // MARK: Route 2
        let routePoints2 = TestResources.points2Array
        let stops2 = TestResources.stops2Array
        line2 = Line(name: "1001", categoryRef: "LineCategories/JY8blWsvs0OXwkozaJlb",
                     routePoints: routePoints2, start: routePoints2[0], stops: stops2, averageVelocity: 30.2)
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

        let result = Algorithm.shared.findAvailableRoutes(origin: originPoint, destination: destinationPoint,
            lines: [line1, line2], minDistanceBtwPoints: minDistance, minDistanceBtwStops: minDistanceBtwStops)
        XCTAssertGreaterThan(result.count, 0)
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

        let result = Algorithm.shared.findAvailableRoutes(origin: originPoint, destination: destinationPoint,
            lines: [line1, line2], minDistanceBtwPoints: minDistance, minDistanceBtwStops: minDistanceBtwStops)
        XCTAssertNotNil(result[0].connectionPoint)
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

        let result = Algorithm.shared.findAvailableRoutes(origin: originPoint, destination: destinationPoint,
            lines: [line1, line2], minDistanceBtwPoints: minDistance, minDistanceBtwStops: minDistanceBtwStops)
        XCTAssertNotNil(result[0].connectionPoint)
    }
}
