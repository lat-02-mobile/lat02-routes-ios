//
//  RouteListManager.swift
//  RoutesApp_ios
//
//  Created by user on 22/9/22.
//

import Foundation

protocol RouteListManagerProtocol {
    func getLines(completion: @escaping(Result<[Lines], Error>) -> Void)
    func getCategories(completion: @escaping (Result<[LinesCategory], Error>) -> Void)
}

class RouteListManager: RouteListManagerProtocol {
    static let shared = RouteListManager()
    let firebaseManager = FirebaseFirestoreManager.shared

    func getLines(completion: @escaping(Result<[Lines], Error>) -> Void) {
        firebaseManager.getLines(type: Lines.self, forCollection: .Lines) { result in
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
}
