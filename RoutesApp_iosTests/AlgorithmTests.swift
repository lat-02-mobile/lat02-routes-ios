//
//  AlgorithmTests.swift
//  RoutesApp_iosTests
//
//  Created by user on 30/8/22.
//

import XCTest
@testable import RoutesApp_ios

class AlgorithmTests: XCTestCase {
    var transportMethod1: TrasportationMethod?
    var transportMethod2: TrasportationMethod?
    var cityRouteForAlgorithm: CityRoute?

    override func setUpWithError() throws {
        // MARK: Route 1
        let routePoints1 = TestResources.points1Array
        let stops1 = TestResources.stops1Array
        transportMethod1 = TrasportationMethod(name: "Bus", lines: [Route(name: "01", routePoints: routePoints1,
           start: routePoints1[0], stops: stops1)])
        // MARK: Route 2
        let routePoints2 = TestResources.points2Array
        let stops2 = TestResources.stops2Array
        transportMethod2 = TrasportationMethod(name: "Mini", lines: [Route(name: "1001", routePoints: routePoints2,
           start: routePoints2[0], stops: stops2)])
        // MARK: CityRoute
        guard let transportMethod1 = transportMethod1,
              let transportMethod2 = transportMethod2 else { return }

        cityRouteForAlgorithm = CityRoute(id: "1", name: "La Paz", transportationMethods: [transportMethod1, transportMethod2])
    }

    override func tearDownWithError() throws {
    }

    func testWhenGivenLinePassThroughOriginDestination() throws {
        let originPoint = Coordinate(latitude: -16.52094, longitude: -68.12419).toCLLocationCoordinate2D()
        let destinationPoint = Coordinate(latitude: -16.52355, longitude: -68.12269).toCLLocationCoordinate2D()
        let minDistance = 200.0
        let minDistanceBtwStops = 200.0

        guard let cityRouteForAlgorithm = cityRouteForAlgorithm else {
            XCTAssertTrue(false)
            return
        }

        let result = Algorithm.shared.findAvailableRoutes(origin: originPoint, destination: destinationPoint,
            cityRoute: cityRouteForAlgorithm, minDistanceBtwPoints: minDistance, minDistanceBtwStops: minDistanceBtwStops)
        XCTAssertGreaterThan(result.count, 0)
    }

    func testWhenGivenLinesAndNeedToCombineRoutes() throws {
        let originPoint = Coordinate(latitude: -16.52094, longitude: -68.12419).toCLLocationCoordinate2D()
        let destinationPoint = Coordinate(latitude: -16.52442, longitude: -68.12036).toCLLocationCoordinate2D()
        let minDistance = 200.0
        let minDistanceBtwStops = 200.0

        guard let cityRouteForAlgorithm = cityRouteForAlgorithm else {
            XCTAssertTrue(false)
            return
        }

        let result = Algorithm.shared.findAvailableRoutes(origin: originPoint, destination: destinationPoint,
            cityRoute: cityRouteForAlgorithm, minDistanceBtwPoints: minDistance, minDistanceBtwStops: minDistanceBtwStops)
        XCTAssertNotNil(result[0].connectionPoint)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
