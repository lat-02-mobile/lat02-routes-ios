//
//  RouteListManager.swift
//  RoutesApp_ios
//
//  Created by user on 22/9/22.
//

import Foundation

protocol LineRouteManagerProtocol {
    func getLineRoute(idLine: String, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void)
    func getLineRouteByDateGreaterThanOrEqualTo(idLine: String, date: Date, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void)
    func getLineRoutesByLine(idLine: String, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void)
    func getLineRoutesByLineAsync(idLine: String) async throws -> [LineRouteInfo]
}

class LineRouteFirebaseManager: LineRouteManagerProtocol {
    static let shared = LineRouteFirebaseManager()
    let firebaseManager = FirebaseFirestoreManager.shared

    func getLineRoute(idLine: String, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void) {
        firebaseManager.getDocumentsByParameterContains(type: LineRouteInfo.self, forCollection: .LineRoute, field: "idLine",
                                                        parameter: idLine) { result in
            switch result {
            case .success(let lines):
                completion(.success(lines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getLineRouteByDateGreaterThanOrEqualTo(idLine: String, date: Date, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void) {
        firebaseManager.getDocumentsByParameterContainsDateGreaterThanOrEqualTo(type: LineRouteInfo.self, forCollection: .LineRoute, field: "idLine",
                                                            fieldDate: "updateAt", date: date, parameter: idLine) { result in
            switch result {
            case .success(let lines):
                completion(.success(lines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getLineRoutesByLine(idLine: String, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void) {
        firebaseManager.getDocumentsByParameterContains(type: LineRouteInfo.self,
                                                        forCollection: .LineRoute,
                                                        field: "idLine",
                                                        parameter: idLine,
                                                        completion: completion)
    }

    func getLineRoutesByLineAsync(idLine: String) async throws -> [LineRouteInfo] {
        do {
            let lineRoutes = try await firebaseManager.getDocumentsByParameterContainsAsync(
                type: LineRouteInfo.self,
                forCollection: .LineRoute,
                field: "idLine",
                parameter: idLine)
            return lineRoutes
        } catch let error {
            throw error
        }
    }
}
