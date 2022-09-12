//
//  SearchLocationTest.swift
//  RoutesApp_iosTests
//
//  Created by Yawar Valeriano on 9/9/22.
//

import XCTest
@testable import GooglePlaces
@testable import RoutesApp_ios

class MockGoogleMapsManager: GoogleMapsManagerProtocol {
    var findPlacesGotCalled = false
    var placeIdToLocationGotCalled = false
    func findPlaces(query: String, placeBias: GMSPlaceLocationBias, completion: @escaping (Result<[Place], Error>) -> Void) {
        if !query.isEmpty {
            completion(.success([TestResources.findPlacesTest]))
            findPlacesGotCalled = true
        } else {
            completion(.failure(NSError(domain: "Error", code: 0)))
            findPlacesGotCalled = false
        }
    }

    func placeIDToLocation(placeID: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        if !placeID.isEmpty {
            completion(.success(CLLocationCoordinate2D()))
            placeIdToLocationGotCalled = true
        } else {
            completion(.failure(NSError(domain: "Error", code: 0)))
            placeIdToLocationGotCalled = false
        }
    }
}

class SearchLocationTest: XCTestCase {

    var searchLocationViewModel = SearchLocationViewModel()
    var mockManager = MockGoogleMapsManager()

    override func setUpWithError() throws {
        mockManager = MockGoogleMapsManager()
        searchLocationViewModel.googleMapsManager = mockManager
    }

    func testGetPlacesThatMatch() {
        searchLocationViewModel.fetchPlaces(query: TestResources.queryToSendTest, placeBias: TestResources.placeBiasTest)
        XCTAssertTrue(mockManager.findPlacesGotCalled)
    }

    func testGetPlacesFailureCase() {
        searchLocationViewModel.fetchPlaces(query: "", placeBias: TestResources.placeBiasTest)
        XCTAssertTrue(!mockManager.findPlacesGotCalled)
    }

    func testGetPlaceCoordinatesByPlaceId() {
        searchLocationViewModel.getPlaceCoordinatesByPlaceId(TestResources.findPlacesTest.identifier) { result in
            XCTAssertNotNil(result)
        }
    }

    func testGetPlaceCoordinatesByPlaceIdFailureCase() {
        searchLocationViewModel.getPlaceCoordinatesByPlaceId("") { result in
            XCTAssertNil(result)
        }
    }
}
