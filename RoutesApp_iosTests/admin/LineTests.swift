//
//  LineTests.swift
//  RoutesApp_iosTests
//
//  Created by Alvaro Choque on 26/10/22.
//

import XCTest
@testable import RoutesApp_ios

class LineTests: XCTestCase {
    var linesViewModel = LinesViewModel()
    var lineManager = MockLineManager()
    var lineCategoryManager = MockLineCategoryManager()
    override func setUpWithError() throws {
        linesViewModel.lineManager = lineManager
        linesViewModel.lineCategoryManager = lineCategoryManager
    }

    func testGetLinesArePopulated() {
        linesViewModel.getLines()
        XCTAssert(linesViewModel.lines.count == 2)
        XCTAssert((linesViewModel.lineManager as? MockLineManager ?? MockLineManager()).getAllLinesGotCalled == true)
    }

    func testGetLineCategoriesArePopulated() {
        linesViewModel.getCategories()
        XCTAssert(linesViewModel.categories.count == 2)
        XCTAssert((linesViewModel.lineCategoryManager as? MockLineCategoryManager ?? MockLineCategoryManager()).getCategoriesGotCalled == true)
    }

    func testWhenFilterQueryIsEmpty() throws {
        linesViewModel.getLines()
        linesViewModel.applyFilters(query: "", selectedCat: nil)
        XCTAssertEqual(linesViewModel.lines.count, 2)
    }

    func testWhenFilterQueryIsNotEmpty() throws {
        linesViewModel.getLines()
        linesViewModel.applyFilters(query: "Line1", selectedCat: nil)
        XCTAssertEqual(linesViewModel.lines.count, 1)
    }
}
