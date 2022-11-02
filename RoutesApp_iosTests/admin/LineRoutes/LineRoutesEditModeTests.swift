//
//  LineRoutesEditModeTests.swift
//  RoutesApp_iosTests
//
//  Created by Alvaro Choque on 1/11/22.
//

import XCTest
@testable import RoutesApp_ios

class LineRoutesEditModeTests: XCTestCase {
    var lineRoutesEditModeViewModel = LineRouteEditModeViewModel()
    override func setUpWithError() throws {
        lineRoutesEditModeViewModel.lineRouteManager = MockLineRouteManager()
        lineRoutesEditModeViewModel.cityManager = MockCityManager()
    }

    func testCreateLineRouteSuccess() {
        lineRoutesEditModeViewModel.createLineRoute(name: "testLine", avgVel: "2.2", color: "#000000",
                                                    start: TestResources.DummyCoords, end: TestResources.DummyCoords,
                                                    routePoints: [TestResources.DummyCoords], stops: [TestResources.DummyCoords])
        XCTAssert((lineRoutesEditModeViewModel.lineRouteManager as? MockLineRouteManager ?? MockLineRouteManager())
            .createLineRouteGotCalled == true)
    }

    func testCreateLineRouteFail() {
        lineRoutesEditModeViewModel.createLineRoute(name: "", avgVel: "2.2", color: "#000000",
                                                    start: TestResources.DummyCoords, end: TestResources.DummyCoords,
                                                    routePoints: [TestResources.DummyCoords], stops: [TestResources.DummyCoords])
        XCTAssert((lineRoutesEditModeViewModel.lineRouteManager as? MockLineRouteManager ?? MockLineRouteManager())
            .createLineRouteGotCalled == false)
    }

    func testUpdateLineRouteSuccess() {
        lineRoutesEditModeViewModel.editLineRoute(targetLineRoute: TestResources.LineRoutes[0], newName: "ffd", newAvgVel: "2.2",
                                                  newColor: "#fffff", newRoutePoitns: [TestResources.DummyCoords],
                                                  newStops: [TestResources.DummyCoords], newStart: TestResources.DummyCoords,
                                                  newEnd: TestResources.DummyCoords)
        XCTAssert((lineRoutesEditModeViewModel.lineRouteManager as? MockLineRouteManager ?? MockLineRouteManager())
            .updateLineRouteGotCalled == true)
    }

    func testUpdateLineRouteFailDueInvalidData() {
        lineRoutesEditModeViewModel.editLineRoute(targetLineRoute: TestResources.LineRoutes[0], newName: "", newAvgVel: "2.2",
                                                  newColor: "#fffff", newRoutePoitns: [TestResources.DummyCoords],
                                                  newStops: [TestResources.DummyCoords], newStart: TestResources.DummyCoords,
                                                  newEnd: TestResources.DummyCoords)
        XCTAssert((lineRoutesEditModeViewModel.lineRouteManager as? MockLineRouteManager ?? MockLineRouteManager())
            .updateLineRouteGotCalled == false)
    }

    func testUpdateLineRouteFailDueInvalidID() {
        let dummyLineRoute = LineRouteInfo(name: TestResources.LineRoutes[0].name, id: "fdsa", idLine: TestResources.LineRoutes[0].idLine,
                                           line: TestResources.LineRoutes[0].line, routePoints: TestResources.LineRoutes[0].routePoints,
                                           start: TestResources.LineRoutes[0].start, stops: TestResources.LineRoutes[0].stops,
                                           end: TestResources.LineRoutes[0].end, averageVelocity: TestResources.LineRoutes[0].averageVelocity,
                                           color: TestResources.LineRoutes[0].color, updateAt: TestResources.LineRoutes[0].updateAt,
                                           createAt: TestResources.LineRoutes[0].createAt)
        lineRoutesEditModeViewModel.editLineRoute(targetLineRoute: dummyLineRoute, newName: "fds", newAvgVel: "2.2",
                                                  newColor: "#fffff", newRoutePoitns: [TestResources.DummyCoords],
                                                  newStops: [TestResources.DummyCoords], newStart: TestResources.DummyCoords,
                                                  newEnd: TestResources.DummyCoords)
        XCTAssert((lineRoutesEditModeViewModel.lineRouteManager as? MockLineRouteManager ?? MockLineRouteManager())
            .updateLineRouteGotCalled == false)
    }

    func testDeleteLineRouteSuccess() {
        lineRoutesEditModeViewModel.deleteLineRoute(idLineRoute: "wsws2344d3f")
        XCTAssert((lineRoutesEditModeViewModel.lineRouteManager as? MockLineRouteManager ?? MockLineRouteManager())
            .deleteLineRouteGotCalled == true)
    }

    func testDeleteLineRouteFail() {
        lineRoutesEditModeViewModel.deleteLineRoute(idLineRoute: "fdsa")
        XCTAssert((lineRoutesEditModeViewModel.lineRouteManager as? MockLineRouteManager ?? MockLineRouteManager())
            .deleteLineRouteGotCalled == false)
    }

    func testGetCityCoords() {
        lineRoutesEditModeViewModel.currLine = TestResources.LinesArray[0]
        lineRoutesEditModeViewModel.getCityCoords()
        XCTAssert((lineRoutesEditModeViewModel.cityManager as? MockCityManager ?? MockCityManager())
            .getCityByIdGotCalled == true)
    }
}
