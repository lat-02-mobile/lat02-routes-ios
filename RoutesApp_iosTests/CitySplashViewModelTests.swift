//
//  CitySplashViewModel.swift
//  RoutesApp_iosTests
//
//  Created by Yawar Valeriano on 10/5/22.
//

import XCTest
@testable import RoutesApp_ios

class CitySplashViewModelTests: XCTestCase {
    var mockManager = MockLocalDataManager()
    var citySplashViewModel = CitySplashViewModel()

    override func setUpWithError() throws {
        mockManager = MockLocalDataManager()
        citySplashViewModel.localDataManager = mockManager
    }

    func testGetAllTourpointsFromCity() throws {
        citySplashViewModel.retrieveAllDataFromFirebaseAndSave()
        XCTAssertTrue(mockManager.dataHasBeenRetrieved)
    }

    func testGetAllTourpointsFromCityFailureCase() throws {
        mockManager.sendWithError = true
        citySplashViewModel.retrieveAllDataFromFirebaseAndSave()
        XCTAssertFalse(mockManager.dataHasBeenRetrieved)
    }
}
