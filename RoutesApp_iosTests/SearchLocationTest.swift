//
//  SearchLocationTest.swift
//  RoutesApp_iosTests
//
//  Created by Yawar Valeriano on 9/9/22.
//

import XCTest
@testable import GooglePlaces
@testable import RoutesApp_ios

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
