//
//  PossibleRoutesTests.swift
//  RoutesApp_iosTests
//
//  Created by user on 23/9/22.
//

import XCTest
@testable import RoutesApp_ios

class PossibleRoutesTests: XCTestCase {
    let possibleRoutesViewModel = PossibleRoutesViewModel()
    var possibleRoutes = [AvailableTransport]()

    override func setUpWithError() throws {
        let routePoints1 = TestResources.points1Array
        let routePoints2 = TestResources.points2Array
        let stops1 = TestResources.stops1Array
        let stops2 = TestResources.stops2Array
        possibleRoutes = [
            AvailableTransport(connectionPoint: nil, transports: [
                LineRoute(name: "Line 1", id: "1", idLine: "", line: "", routePoints: routePoints1,
                  start: routePoints1[0], stops: stops1, end: routePoints1.last!, averageVelocity: 3.2,
                  blackIcon: "", whiteIcon: "", color: "#FFFFF")
            ]),
            AvailableTransport(connectionPoint: nil, transports: [
                LineRoute(name: "Line 2", id: "2", idLine: "", line: "", routePoints: routePoints2,
                  start: routePoints2[0], stops: stops2, end: routePoints2.last!, averageVelocity: 3.2,
                  blackIcon: "", whiteIcon: "", color: "#FF1FF")
            ])
        ]
        possibleRoutesViewModel.possibleRoutes = possibleRoutes
    }

    func testWhenSortTheLinesByShortestDistance() {
        possibleRoutesViewModel.sortPossibleRoutes()
        XCTAssertEqual(possibleRoutesViewModel.possibleRoutes[1], possibleRoutes[0])
    }
}
