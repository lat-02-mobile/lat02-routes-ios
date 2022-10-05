import XCTest
@testable import RoutesApp_ios

class MockLineCategoryManager: LineCategoryManagerProtocol {
    var hasCategories = true
    func getLineCategoryByIdAsync(lineId: String) async throws -> LinesCategory {
        TestResources.lineCategories.first!
    }

    func getCategories(completion: @escaping (Result<[LinesCategory], Error>) -> Void) {
        if hasCategories {
            completion(.success(TestResources.lineCategories))
            return
        }
        completion(.failure(NSError(domain: "Error", code: 0)))
    }
}

class MockLineManager: LineManagerProtocol {
    var hasLines = true
    func getLines(completion: @escaping (Result<[Lines], Error>) -> Void) {
        if hasLines {
            completion(.success(TestResources.lines))
            return
        }
        completion(.failure(NSError(domain: "Error", code: 0)))
    }

    func getLineByIdAsync(lineId: String) async throws -> Lines {
        return TestResources.lines.first!
    }

    func getLinesByCity(cityId: String, completion: @escaping (Result<[Lines], Error>) -> Void) {
        if hasLines {
            completion(.success(TestResources.lines))
            return
        }
        completion(.failure(NSError(domain: "Error", code: 0)))
    }

    func getLinesByCityAsync(cityId: String) async throws -> [Lines] {
        return TestResources.lines
    }

    func getLinesForCurrentCity(completion: @escaping (Result<[Lines], Error>) -> Void) {
        if hasLines {
            completion(.success(TestResources.lines))
            return
        }
        completion(.failure(NSError(domain: "Error", code: 0)))
    }
}

class MockLineRouteManager: LineRouteManagerProtocol {
    var hasLines = true
    func getLinesRoutesByLineAsync(idLine: String) async throws -> [LineRouteInfo] {
        return []
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
    var lineRouteManager = MockLineRouteManager()
    var lineCategoryManager = MockLineCategoryManager()
    var lineManager = MockLineManager()
    var routeListViewModel = RouteListViewModel()

    override func setUpWithError() throws {
        routeListViewModel.lineRouteManager = lineRouteManager
        routeListViewModel.lineCategoryManager = lineCategoryManager
        routeListViewModel.lineManager = lineManager
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
