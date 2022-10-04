//
//  LineCategoryManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 29/9/22.
//

import Foundation

protocol LineCategoryManagerProtocol {
    func getLineCategoryByIdAsync(lineId: String) async throws -> LinesCategory
    func getCategories(completion: @escaping (Result<[LinesCategory], Error>) -> Void)
}

class LineCategoryFirebaseManager: LineCategoryManagerProtocol {
    let firebaseManager = FirebaseFirestoreManager.shared
    static let shared = LineCategoryFirebaseManager()

    func getLineCategoryByIdAsync(lineId: String) async throws -> LinesCategory {
        do {
            let lineCategory = try await firebaseManager.getDocumentByIdAsync(docId: lineId, type: LinesCategory.self, forCollection: .LineCategories)
            return lineCategory
        } catch let error {
            throw error
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
