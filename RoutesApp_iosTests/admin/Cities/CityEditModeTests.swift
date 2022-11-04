//
//  CityEditModeTests.swift
//  RoutesApp_iosTests
//
//  Created by user on 3/11/22.
//

import XCTest
@testable import RoutesApp_ios

class CityEditModeTests: XCTestCase {

    var cityViewModel = CityViewModel()
    var cityManager = MockCityManager()

    override func setUpWithError() throws {
        cityViewModel.cityManager = cityManager
    }

    func testWhenAddCity() throws {
        let cityName = "Beni"
        cityViewModel.createCity(name: cityName, latitude: "-65.2", longitude: "-17.2", country: "Bolivia", idCountry: "1") { result in
            switch result {
            case.success(let city):
                XCTAssertTrue(city.name == cityName)
            case.failure:
                XCTAssertTrue(false)
            }
        }
    }

    func testWhenEditCity() throws {
        cityViewModel.countryId = "countryTest"
        cityViewModel.getCities()
        let cities = cityViewModel.cities
        let oldCity = cities[0]
        let newName = "Pando"
        let newLatitude = "-10.20"
        let newLongitude = "-30.2"
        cityViewModel.updateCity(id: oldCity.id, name: newName, latitude: newLatitude, longitude: newLongitude, country: oldCity.country,
                                 idCountry: oldCity.idCountry) { result in
            switch result {
            case.success:
                XCTAssertTrue((self.cityViewModel.cityManager as? MockCityManager ?? MockCityManager()).updateCityGotCalled == true)
            case.failure:
                XCTAssertTrue(false)
            }
        }
    }

    func testWhenRemoveCity() throws {
        cityViewModel.countryId = "countryTest"
        cityViewModel.getCities()
        let cities = cityViewModel.cities
        let cityToRemove = cities[0]
        cityViewModel.cityManager.deleteCity(cityId: cityToRemove.id) { result in
            switch result {
            case.success:
                XCTAssertTrue((self.cityViewModel.cityManager as? MockCityManager ?? MockCityManager()).deleteCityGotCalled == true)
            case.failure:
                XCTAssertTrue(false)
            }
        }
    }
}
