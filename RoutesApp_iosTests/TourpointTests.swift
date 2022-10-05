//
//  TourpointTests.swift
//  RoutesApp_iosTests
//
//  Created by Yawar Valeriano on 9/29/22.
//

import XCTest
@testable import RoutesApp_ios

class MockTourpointsManager: TourpointsManagerProtocol {
    var tourpointsCalled = false
    var tourpointsCategoryCalled = false
    var sendToError = false
    func getTourpointList(completion: @escaping (Result<[Tourpoint], Error>) -> Void) {
        if !sendToError {
            tourpointsCalled = true
            completion(.success(TestResources.tourpoints))
        } else {
            tourpointsCalled = false
            completion(.failure(NSError(domain: "Error", code: 0)))
        }
    }

    func getTourpointCategories(completion: @escaping (Result<[TourpointCategory], Error>) -> Void) {
        if !sendToError {
            tourpointsCategoryCalled = true
            completion(.success(TestResources.tourpointCategories))
        } else {
            tourpointsCategoryCalled = false
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
        XCTAssertTrue(mockManager.tourpointsCalled)
        XCTAssertTrue(mockManager.tourpointsCategoryCalled)
    }

    func testGetAllTourpointsFromCityFailureCase() throws {
        mockManager.sendToError = true
        tourpointsViewModel.getTourpoints()
        XCTAssertFalse(mockManager.tourpointsCalled)
        XCTAssertFalse(mockManager.tourpointsCategoryCalled)
    }
}
