//
//  CitySplashViewModel.swift
//  RoutesApp_iosTests
//
//  Created by Yawar Valeriano on 10/5/22.
//

import XCTest
@testable import RoutesApp_ios

class MockLocalDataManager: LocalDataManagerProtocol {
    var dataHasBeenRetrieved = false
    var sendWithError = false
    func retrieveAllDataFromFirebase(completion: @escaping (Result<Void, Error>) -> Void) {
        if sendWithError {
            completion(.failure(NSError(domain: "Error", code: 0)))
        } else {
            dataHasBeenRetrieved = true
            completion(.success(()))
        }
    }
}

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
