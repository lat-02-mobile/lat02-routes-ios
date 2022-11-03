//
//  TourpointTests.swift
//  RoutesApp_iosTests
//
//  Created by Yawar Valeriano on 9/29/22.
//

import XCTest
@testable import RoutesApp_ios

class TourpointTests: XCTestCase {

    var tourpointsViewModel = TourpointsViewModel()
    var mockManager = MockLocalDataManager()

    override func setUpWithError() throws {
        mockManager = MockLocalDataManager()
        tourpointsViewModel.localDataManager = mockManager
    }

    func testGetAllTourpointsFromCity() throws {
        tourpointsViewModel.getTourpoints()
        XCTAssertTrue(mockManager.tourpointsCalled)
        XCTAssertTrue(mockManager.tourpointsCategoryCalled)
    }

    func testGetAllTourpointsFromCityFailureCase() throws {
        mockManager.sendWithError = true
        tourpointsViewModel.getTourpoints()
        XCTAssertFalse(mockManager.tourpointsCalled)
        XCTAssertFalse(mockManager.tourpointsCategoryCalled)
    }

    func testFilterTourPointsByText() {
        tourpointsViewModel.getTourpoints()
        tourpointsViewModel.applyFilters(query: "1Line", selectedCat: nil)
        XCTAssert(tourpointsViewModel.tourpointList.count == 1)
    }

    func testFilterTourPointsByCategoryWithoutText() {
        tourpointsViewModel.getTourpoints()
        tourpointsViewModel.applyFilters(query: "", selectedCat: tourpointsViewModel.categories[0])
        XCTAssert(tourpointsViewModel.tourpointList.count == 2)
    }

    func testFilterTourPointsByCategoryWithText() {
        tourpointsViewModel.getTourpoints()
        tourpointsViewModel.applyFilters(query: "1Line", selectedCat: tourpointsViewModel.categories[0])
        XCTAssert(tourpointsViewModel.tourpointList.count == 1)
    }
}
