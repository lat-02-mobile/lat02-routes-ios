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
}

class RouteListManager: RouteListManagerProtocol {
    static let shared = RouteListManager()
    let firebaseManager = FirebaseFirestoreManager.shared

    func getLines(completion: @escaping(Result<[Lines], Error>) -> Void) {
        firebaseManager.getDocumentsFromCity(type: Lines.self, forCollection: .Lines) { result in
            switch result {
            case .success(let lines):
                let enabledLines = lines.filter { line in
                    guard let enabledLine = line.enable else { return false }
                    return enabledLine
                }
                completion(.success(enabledLines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
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
    func getCategories(completion: @escaping (Result<[LinesCategory], Error>) -> Void) {
        firebaseManager.getDocuments(type: LinesCategory.self, forCollection: .LineCategories) { result in
            switch result {
            case .success(let lines):
                completion(.success(lines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
