//
//  LineFirebaseManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 29/9/22.
//

import Foundation

class LineFirebaseManager {
    let firebaseManager = FirebaseFirestoreManager.shared
    static let shared = LineFirebaseManager()

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

    func getLineByIdAsync(lineId: String) async throws -> Lines {
        do {
            let line = try await firebaseManager.getDocumentByIdAsync(docId: lineId, type: Lines.self, forCollection: .Lines)
            return line
        } catch let error {
            throw error
        }
    }

    func getLinesByCity(cityId: String, completion: @escaping(Result<[Lines], Error>) -> Void) {
        firebaseManager.getLineWithBooleanCondition(type: Lines.self, forCollection: .Lines, enable: true) { result in
            switch result {
            case .success(let lines):
                let finalLines = lines.filter({$0.idCity == cityId})
                completion(.success(finalLines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getLinesByCityAsync(cityId: String) async throws -> [Lines] {
        do {
            let lines = try await firebaseManager.getDocumentsAsync(type: Lines.self, forCollection: .Lines)
            let finalLines = lines.filter({$0.idCity == cityId && $0.enable == true})
            return finalLines
        } catch let error {
            throw error
        }
    }
}
