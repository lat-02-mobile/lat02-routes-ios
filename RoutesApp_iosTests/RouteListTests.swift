import XCTest
import CoreData
@testable import RoutesApp_ios

class RouteListTests: XCTestCase {
    var localDataManager = MockLocalDataManager()
    var routeListViewModel = RouteListViewModel()

    override func setUpWithError() throws {
        routeListViewModel.localDataManager = localDataManager
        routeListViewModel.getLines()
    }

    func testWhenFilterQueryIsEmpty() throws {
        routeListViewModel.applyFilters(query: "", selectedCat: nil)
        XCTAssertEqual(routeListViewModel.lines.count, 3)
    }

    func testWhenFilterQueryIsNotEmpty() throws {
        routeListViewModel.applyFilters(query: "72", selectedCat: nil)
        XCTAssertEqual(self.routeListViewModel.lines.count, 1)
    }

    func testWhenFilterCategoryIsSelected() throws {
        routeListViewModel.applyFilters(query: "", selectedCat: routeListViewModel.categories[0])
        XCTAssertEqual(self.routeListViewModel.lines.count, 1)
    }

    func testWhenFilterQueryAndCategoryIsSelected() throws {
        routeListViewModel.applyFilters(query: "72", selectedCat: routeListViewModel.categories[1])
        XCTAssertEqual(self.routeListViewModel.lines.count, 1)
    }
}
