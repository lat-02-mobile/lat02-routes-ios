import XCTest
@testable import RoutesApp_ios

class MockRouteListManager: RouteListManagerProtocol {
    var hasLines = true
    var hasCategories = true
    func getLines(completion: @escaping (Result<[Lines], Error>) -> Void) {
        if hasLines {
            completion(.success(TestResources.lines))
            return
        }
        completion(.failure(NSError(domain: "Error", code: 0)))
    }

    func getCategories(completion: @escaping (Result<[LinesCategory], Error>) -> Void) {
        if hasCategories {
            completion(.success(TestResources.lineCategories))
            return
        }
        completion(.failure(NSError(domain: "Error", code: 0)))
    }

    func getLineRoute(idLine: String, completion: @escaping (Result<[LineRouteInfo], Error>) -> Void) {
            if hasLines {
                completion(.success(TestResources.LineRoutes))
                return
            }
            completion(.failure(NSError(domain: "Error", code: 0)))
        }
}

class RouteListTests: XCTestCase {
    var routeListManager = MockRouteListManager()
    var routeListViewModel = RouteListViewModel()

    override func setUpWithError() throws {
        routeListViewModel.routeListManager = routeListManager
        routeListViewModel.getLines {}
    }

    func testWhenFilterQueryIsEmpty() throws {
        routeListViewModel.filterRouteListBy(query: "")
        XCTAssertEqual(routeListViewModel.filteredRouteList.count, 3)
    }

    func testWhenFilterQueryIsNotEmpty() throws {
        self.routeListViewModel.filterRouteListBy(query: "72")
        XCTAssertEqual(self.routeListViewModel.filteredByQueryRouteList.count, 1)
    }

    func testWhenFilterCategoryIsSelected() throws {
        self.routeListViewModel.filterRouteListBy(transportationCategory: self.routeListViewModel.linesCategory[0])
        XCTAssertEqual(self.routeListViewModel.filteredByCategoryRouteList.count, 1)
    }

    func testWhenFilterQueryAndCategoryIsSelected() throws {
        self.routeListViewModel.filterRouteListBy(transportationCategory: self.routeListViewModel.linesCategory[1])
        self.routeListViewModel.filterRouteListBy(query: "72")
        XCTAssertEqual(self.routeListViewModel.filteredRouteList.count, 1)
    }
}
