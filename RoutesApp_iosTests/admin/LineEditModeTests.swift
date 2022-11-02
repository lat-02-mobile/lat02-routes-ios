//
//  LineEditModeTests.swift
//  RoutesApp_iosTests
//
//  Created by Alvaro Choque on 26/10/22.
//

import XCTest
@testable import RoutesApp_ios

class LineEditModeTests: XCTestCase {
    var lineEditModeViewModel = LineEditModeViewModel()
    override func setUpWithError() throws {
        lineEditModeViewModel.lineCategoryManager = MockLineCategoryManager()
        lineEditModeViewModel.cityManager = MockCityManager()
        lineEditModeViewModel.lineManager = MockLineManager()
        (lineEditModeViewModel.lineManager as? LineFirebaseManager ?? LineFirebaseManager()).lineRouteFirebaseManager = MockLineRouteManager()
    }

    func testIfCategoriesArePopulated() {
        lineEditModeViewModel.getCategories()
        XCTAssert(lineEditModeViewModel.categories.count == 2)
        XCTAssert((lineEditModeViewModel.lineCategoryManager as? MockLineCategoryManager ?? MockLineCategoryManager()).getCategoriesGotCalled == true)
    }

    func testIfCitiesArePopulated() {
        lineEditModeViewModel.getCities()
        XCTAssert(lineEditModeViewModel.cities.count == 1)
        XCTAssert((lineEditModeViewModel.cityManager as? MockCityManager ?? MockCityManager()).getCitiesGotCalled == true)
    }

    func testCreateNewLineSuccess() {
        lineEditModeViewModel.createNewLine(newLineName: "Line1", idCategory: "Category1", idCity: "City1")
        XCTAssert((lineEditModeViewModel.lineManager as? MockLineManager ?? MockLineManager()).createNewLineGotCalled == true)
    }

    func testCreateNewLineFail() {
        lineEditModeViewModel.createNewLine(newLineName: "", idCategory: "Category1", idCity: "City1")
        XCTAssert((lineEditModeViewModel.lineManager as? MockLineManager ?? MockLineManager()).createNewLineGotCalled == false)
    }

    func testEditLineSuccess() {
        lineEditModeViewModel.editLine(targetLine: TestResources.Line1,
                                       newLineName: "222",
                                       newIdCategory: "333",
                                       newIdCity: "City3",
                                       newEnable: false)
        XCTAssert((lineEditModeViewModel.lineManager as? MockLineManager ?? MockLineManager()).updateLineGotCalled == true)
    }

    func testEditLineFail() {
        lineEditModeViewModel.editLine(targetLine: TestResources.Line1, newLineName: "", newIdCategory: "333", newIdCity: "City3", newEnable: false)
        XCTAssert((lineEditModeViewModel.lineManager as? MockLineManager ?? MockLineManager()).updateLineGotCalled == false)
    }

    func testDeleteLineFail() {
        lineEditModeViewModel.deleteLine(idLine: "1")
        XCTAssert((lineEditModeViewModel.lineManager as? MockLineManager ?? MockLineManager()).deleteLineGotCalled == false)
    }

    func testDeleteLineSuccess() {
        lineEditModeViewModel.deleteLine(idLine: "3")
        XCTAssert((lineEditModeViewModel.lineManager as? MockLineManager ?? MockLineManager()).deleteLineGotCalled == true)
    }
}
