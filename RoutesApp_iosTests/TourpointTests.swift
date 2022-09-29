//
//  TourpointTests.swift
//  RoutesApp_iosTests
//
//  Created by Yawar Valeriano on 9/29/22.
//

import XCTest
@testable import RoutesApp_ios

class MockTourpointsManager: TourpointsManagerProtocol {
    var tourpointsAndCategoriesCalled = false
    var sendToError = false
    func getTourpointList(completion: @escaping (Result<[TourpointInfo], Error>) -> Void) {
        if !sendToError {
            tourpointsAndCategoriesCalled = true
            completion(.success(TestResources.tourpointsInfo))
        } else {
            tourpointsAndCategoriesCalled = false
            completion(.failure(NSError(domain: "Error", code: 0)))
        }
    }

}

class TourpointTests: XCTestCase {

    var tourpointsViewModel = TourpointsViewModel()
    var mockManager = MockTourpointsManager()

    override func setUpWithError() throws {
        mockManager = MockTourpointsManager()
        tourpointsViewModel.tourpointsManager = mockManager
    }

    func testGetAllTourpointsFromCity() throws {
        tourpointsViewModel.getTourpoints()
        XCTAssertTrue(mockManager.tourpointsAndCategoriesCalled)
    }

    func testGetAllTourpointsFromCityFailureCase() throws {
        mockManager.sendToError = true
        tourpointsViewModel.getTourpoints()
        XCTAssertFalse(mockManager.tourpointsAndCategoriesCalled)
    }
}
