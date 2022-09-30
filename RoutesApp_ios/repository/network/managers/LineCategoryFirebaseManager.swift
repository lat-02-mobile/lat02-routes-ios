//
//  LineCategoryManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 29/9/22.
//

import Foundation

class LineCategoryFirebaseManager {
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
}
