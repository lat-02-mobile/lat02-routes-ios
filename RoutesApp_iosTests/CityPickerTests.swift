//
//  CityPickerTests.swift
//  RoutesApp_iosTests
//
//  Created by admin on 8/25/22.
//

import XCTest
@testable import RoutesApp_ios

class MockCityManager: CityManagerProtocol {
    var getCitiesByNameGotCalled = false
    var getCitiesGotCalled = false
    func getCitiesByName(parameter: String, completion: @escaping (Result<[Cities], Error>) -> Void) {
        if !parameter.isEmpty {
            completion(.success([TestResources.testCityRoute]))
            getCitiesByNameGotCalled = true
        } else {
            completion(.failure(NSError(domain: "Error", code: 0)))
            getCitiesByNameGotCalled = false
        }
    }
    func getCountryById(id: String, completion: @escaping (Result<[Country], Error>) -> Void) {
        if !id.isEmpty {
            completion(.success([TestResources.testCountry]))
        } else {
            completion(.failure(NSError(domain: "Error", code: 0)))
        }
    }
    func getCities(completion: @escaping (Result<[Cities], Error>) -> Void) {
        completion(.success([TestResources.testCityRoute]))
        getCitiesGotCalled = true
    }
}

class CityPickerTests: XCTestCase {
    var cityPickerViewModel = CityPickerViewModel()
    override func setUpWithError() throws {
        cityPickerViewModel.cityManager = MockCityManager()
    }
    func testGetCities() {
        cityPickerViewModel.getCities()
        XCTAssert((cityPickerViewModel.cityManager as? MockCityManager ?? MockCityManager()).getCitiesGotCalled == true)
    }
    func testGetCitiesByNameSuccessCase() {
        cityPickerViewModel.getCitiesByName(text: TestResources.testCityRouteName)
        XCTAssert((cityPickerViewModel.cityManager as? MockCityManager ?? MockCityManager()).getCitiesByNameGotCalled == true)
    }
    func testGetCitiesByNameFailureCase() {
        cityPickerViewModel.getCitiesByName(text: "")
        XCTAssert((cityPickerViewModel.cityManager as? MockCityManager ?? MockCityManager()).getCitiesByNameGotCalled == false)
    }
    func testGetCountryByIdSuccessCase() {
        cityPickerViewModel.getCountry(id: TestResources.testCountryId) { result in
            XCTAssertNotNil(result)
        }
    }
    func testGetCountryByIdFailureCase() {
        cityPickerViewModel.getCountry(id: "") { result in
            XCTAssertNil(result)
        }
    }
}
