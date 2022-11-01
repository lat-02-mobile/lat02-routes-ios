//
//  MockManagers.swift
//  RoutesApp_iosTests
//
//  Created by Alvaro Choque on 26/10/22.
//

import Foundation
import FirebaseFirestore
@testable import RoutesApp_ios

class MockLineManager: LineManagerProtocol {
    var getAllLinesGotCalled = false
    var createNewLineGotCalled = false
    var updateLineGotCalled = false
    var deleteLineGotCalled = false
    func createNewLine(newLineName: String, idCategory: String, idCity: String, completion: @escaping (Result<Lines, Error>) -> Void) {
        createNewLineGotCalled = true
        let newLineId = "1111"
        guard !idCategory.isEmpty else {return}
        let newLine = Lines(categoryRef: TestResources.Line1.categoryRef,
                            enable: false,
                            id: newLineId,
                            idCity: idCity,
                            idCategory: idCategory,
                            name: newLineName,
                            updateAt: TestResources.timestamp,
                            createAt: TestResources.timestamp
        )
        completion(.success(newLine))
    }

    func getAllLines(completion: @escaping (Result<[Lines], Error>) -> Void) {
        getAllLinesGotCalled = true
        completion(.success(TestResources.LinesArray))
    }

    func getEnabledLines(completion: @escaping (Result<[Lines], Error>) -> Void) {
    }

    func getLineByIdAsync(lineId: String) async throws -> Lines {
        return TestResources.Line1
    }

    func getLinesByCity(cityId: String, completion: @escaping (Result<[Lines], Error>) -> Void) {
    }

    func getLinesByCityAsync(cityId: String) async throws -> [Lines] {
        return TestResources.LinesArray
    }

    func getLinesForCurrentCity(completion: @escaping (Result<[Lines], Error>) -> Void) {
    }

    func updateLine(line: Lines, newLineName: String, newIdCategory: String, newIdCity: String, newEnable: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        updateLineGotCalled = true
        completion(.success(true))
    }

    func deleteLine(idLine: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let finalLineRoutes = TestResources.LineRoutes.filter({$0.idLine == idLine})
        if finalLineRoutes.isEmpty {
            deleteLineGotCalled = true
        } else {
            deleteLineGotCalled = false
        }
    }
}

class MockLineCategoryManager: LineCategoryManagerProtocol {
    var getCategoriesGotCalled = false
    func getLineCategoryByIdAsync(lineId: String) async throws -> LinesCategory {
        return TestResources.lineCategories[0]
    }

    func getCategories(completion: @escaping (Result<[LinesCategory], Error>) -> Void) {
        getCategoriesGotCalled = true
        completion(.success(TestResources.lineCategories))
    }

    func getCategoriesByDate(date: Date, completion: @escaping (Result<[LinesCategory], Error>) -> Void) {
    }
}

class MockLineRouteManager: LineRouteManagerProtocol {
    var getLineRoutesByLineGotCalled = false
    var createLineRouteGotCalled = false
    var updateLineRouteGotCalled = false
    var deleteLineRouteGotCalled = false

    func createNewLineRoute(idLine: String, lineRouteName: String, avgVel: String, color: String, start: GeoPoint, end: GeoPoint, routePoints: [GeoPoint], stops: [GeoPoint], completion: @escaping (Result<LineRouteInfo, Error>) -> Void) {
        createLineRouteGotCalled = true
        completion(.success(LineRouteInfo(name: lineRouteName, id: "111", idLine: idLine, line: nil,
                                          routePoints: routePoints, start: start, stops: stops, end: end, averageVelocity: avgVel,
                                          color: color, updateAt: Timestamp(), createAt: Timestamp())))
    }

    func updateLineRoute(lineRoute: LineRouteInfo, newLineRouteName: String, newAvgVel: String, newColor: String, newRoutePoints: [GeoPoint], newStops: [GeoPoint], newStart: GeoPoint, newEnd: GeoPoint, completion: @escaping (Result<Bool, Error>) -> Void) {
        let foundLineRoute = TestResources.LineRoutes.first(where: {$0.id == lineRoute.id})
        if foundLineRoute != nil {
            updateLineRouteGotCalled = true
            completion(.success(true))
        } else {
            updateLineRouteGotCalled = false
            completion(.success(false))
        }
    }

    func deleteLineRoute(idLineRoute: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let foundLineRoute = TestResources.LineRoutes.first(where: {$0.id == idLineRoute})
        if foundLineRoute != nil {
            deleteLineRouteGotCalled = true
            completion(.success(true))
        } else {
            deleteLineRouteGotCalled = false
            completion(.success(false))
        }
    }

    func getLineRoute(idLine: String, completion: @escaping (Result<[LineRouteInfo], Error>) -> Void) {
    }

    func getLineRouteByDateGreaterThanOrEqualTo(idLine: String, date: Date, completion: @escaping (Result<[LineRouteInfo], Error>) -> Void) {
    }

    func getLineRoutesByLine(idLine: String, completion: @escaping (Result<[LineRouteInfo], Error>) -> Void) {
        getLineRoutesByLineGotCalled = true
        let finalLineRoutes = TestResources.LineRoutes.filter({$0.idLine == idLine})
        completion(.success(finalLineRoutes))
    }

    func getLineRoutesByLineAsync(idLine: String) async throws -> [LineRouteInfo] {
        return TestResources.LineRoutes
    }
}
