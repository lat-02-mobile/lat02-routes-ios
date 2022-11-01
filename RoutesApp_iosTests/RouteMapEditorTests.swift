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
    let context = MockLocalDataManager.setUpInMemoryManagedObjectContext()
    var entity = LineRouteEntity()

    override func setUpWithError() throws {
        let lineRoute = TestResources.LineRoutes[0]
        entity = LineRouteEntity(context: context)
        entity.averageVelocity = lineRoute.averageVelocity
        entity.color = lineRoute.color
        entity.createAt = Date()
        entity.end = lineRoute.end.toCoordinate()
        entity.id = lineRoute.id
        entity.routePoints = lineRoute.routePoints.map({ $0.toCoordinate() })
        entity.start = lineRoute.start.toCoordinate()
        entity.stops = lineRoute.stops.map({ $0.toCoordinate() })
        routeMapEditorViewModel.setLinePath(linePath: entity)
    }

    func testLinePathIsSet() throws {
        XCTAssertEqual(entity, routeMapEditorViewModel.getLinePath())
    }

    func testWhenAddRoutePoint() throws {
        let coordinate = Coordinate(latitude: 20.0, longitude: 20.0)
        routeMapEditorViewModel.addCoordinate(coorditate: coordinate)
        XCTAssertEqual(routeMapEditorViewModel.getLinePath().routePoints.last, coordinate)
    }

    func testWhenConvertToStop() throws {
        let linePath = routeMapEditorViewModel.getLinePath()
        let routePoint = linePath.routePoints[0]
        routeMapEditorViewModel.convertToStop(coorditate: routePoint)
        XCTAssertTrue(linePath.stops.contains(routePoint))
    }

    func testRemoveRoutePoint() throws {
        let linePath = routeMapEditorViewModel.getLinePath()
        let routePoint = linePath.routePoints[0]
        routeMapEditorViewModel.removeRoutePoint(at: routePoint)
        XCTAssertFalse(linePath.routePoints.contains(routePoint))
    }

    func testRemoveStop() throws {
        let linePath = routeMapEditorViewModel.getLinePath()
        let stop = linePath.stops[0]
        routeMapEditorViewModel.removeStop(at: stop)
        XCTAssertFalse(linePath.stops.contains(stop))
    }
}
