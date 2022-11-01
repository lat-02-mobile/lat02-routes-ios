//
//  LineRoutesTests.swift
//  RoutesApp_iosTests
//
//  Created by Alvaro Choque on 1/11/22.
//

import XCTest
@testable import RoutesApp_ios

class LineRouteTests: XCTestCase {
    var lineRoutesViewModel = AdminLineRouteViewModel()
    var lineRouteManager = MockLineRouteManager()
    override func setUpWithError() throws {
        lineRoutesViewModel.lineRoutesManager = lineRouteManager
    }

    func testIfTheLineHasRoutes() {
        lineRoutesViewModel.currIdLine = "1"
        lineRoutesViewModel.getLineRoutes()
        XCTAssert(lineRoutesViewModel.lineRoutes.count == 2)
    }

    func testIfTheLineDoNotHaveAnyRoutes() {
        lineRoutesViewModel.currIdLine = "2"
        lineRoutesViewModel.getLineRoutes()
        XCTAssert(lineRoutesViewModel.lineRoutes.isEmpty)
    }
}
