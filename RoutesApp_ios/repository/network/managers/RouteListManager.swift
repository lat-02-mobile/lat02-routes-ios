//
//  RouteListManager.swift
//  RoutesApp_ios
//
//  Created by user on 22/9/22.
//

import Foundation

protocol RouteListManagerProtocol {
    func getLines(completion: @escaping(Result<[Lines], Error>) -> Void)
    func getLineRoute(idLine: String, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void)
    func getCategories(completion: @escaping (Result<[LinesCategory], Error>) -> Void)
    func getLinesRoutesByLineAsync(idLine: String) async throws -> [LineRouteInfo]
}

class RouteListManager: RouteListManagerProtocol {
    static let shared = RouteListManager()
    let firebaseManager = FirebaseFirestoreManager.shared

    func getLines(completion: @escaping(Result<[Lines], Error>) -> Void) {
        firebaseManager.getLineWithBooleanCondition(type: Lines.self, forCollection: .Lines, enable: true) { result in
            switch result {
            case .success(let lines):
                completion(.success(lines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getLineRoute(idLine: String, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void) {
        firebaseManager.getLineRoute(type: LineRouteInfo.self, forCollection: .LineRoute, id: idLine ) { result in
            switch result {
            case .success(let lines):
                completion(.success(lines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCategories(completion: @escaping (Result<[LinesCategory], Error>) -> Void) {
        firebaseManager.getLinesCategory(type: LinesCategory.self, forCollection: .Lines) { result in
            switch result {
            case .success(let lines):
                completion(.success(lines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getLinesRoutesByLineAsync(idLine: String) async throws -> [LineRouteInfo] {
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
