//
//  RouteMapEditor.swift
//  RoutesApp_iosTests
//
//  Created by user on 1/11/22.
//

import XCTest
@testable import RoutesApp_ios

class RouteMapEditorTests: XCTestCase {

    var routeMapEditorViewModel = RoutesMapEditorViewModel()
    let lineRoute = TestResources.LineRoutes[0]

    override func setUpWithError() throws {
        routeMapEditorViewModel.setLinePath(linePath: lineRoute)
    }

    func testLinePathIsSet() throws {
        XCTAssertEqual(lineRoute, routeMapEditorViewModel.getLinePath())
    }

    func testWhenAddRoutePoint() throws {
        let coordinate = Coordinate(latitude: 30.0, longitude: 30.0)
        routeMapEditorViewModel.addCoordinate(coorditate: coordinate)
        XCTAssertEqual(routeMapEditorViewModel.getLinePath()?.routePoints.last, coordinate.toGeoCode())
    }

    func testWhenConvertToStop() throws {
        guard let linePath = routeMapEditorViewModel.getLinePath() else {
            XCTAssertTrue(false)
            return
        }
        let routePoint = linePath.routePoints[0]
        routeMapEditorViewModel.convertToStop(coorditate: routePoint.toCoordinate())
        XCTAssertTrue(linePath.stops.contains(routePoint))
    }

    func testRemoveRoutePoint() throws {
        guard let linePath = routeMapEditorViewModel.getLinePath() else {
            XCTAssertTrue(false)
            return
        }
        let routePoint = linePath.routePoints[0]
        routeMapEditorViewModel.removeRoutePoint(at: routePoint.toCoordinate())
        XCTAssertFalse(routeMapEditorViewModel.getLinePath()?.routePoints.contains(routePoint) ?? true)
    }

    func testRemoveStop() throws {
        guard let linePath = routeMapEditorViewModel.getLinePath() else {
            XCTAssertTrue(false)
            return
        }
        let stop = linePath.stops[0]
        routeMapEditorViewModel.removeStop(at: stop.toCoordinate())
        XCTAssertFalse(routeMapEditorViewModel.getLinePath()?.stops.contains(stop) ?? true)
    }
}
