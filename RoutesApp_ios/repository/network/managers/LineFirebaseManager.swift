//
//  LineFirebaseManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 29/9/22.
//

import Foundation

protocol LineManagerProtocol {
    func createNewLine(newLineName: String, idCategory: String, idCity: String)
    func getLines(completion: @escaping(Result<[Lines], Error>) -> Void)
    func getLineByIdAsync(lineId: String) async throws -> Lines
    func getLinesByCity(cityId: String, completion: @escaping(Result<[Lines], Error>) -> Void)
    func getLinesByCityAsync(cityId: String) async throws -> [Lines]
    func getLinesForCurrentCity(completion: @escaping(Result<[Lines], Error>) -> Void)
}

class LineFirebaseManager: LineManagerProtocol {
    let firebaseManager = FirebaseFirestoreManager.shared
    static let shared = LineFirebaseManager()
    let cityManager = CityFirebaseManager.shared

    func createNewLine(newLineName: String, idCategory: String, idCity: String) {
        let newLineId = firebaseManager.getDocID(forCollection: .Lines)
        let newLine = Lines(categoryRef: firebaseManager.db.document("LineCategories/\(idCategory)"),
                            enable: false,
                            id: newLineId,
                            idCity: idCity,
                            idCategory: idCategory,
                            name: newLineName)
//        firebaseManager.addDocument(document: <#T##BaseModel & Encodable#>,
//                                    collection: <#T##FirebaseCollections#>,
//                                    completion: <#T##(Result<BaseModel & Encodable, Error>) -> Void#>)
    }

    func getLines(completion: @escaping(Result<[Lines], Error>) -> Void) {
        firebaseManager.getDocuments(type: Lines.self, forCollection: .Lines) { result in
            switch result {
            case .success(let lines):
                let finalLines = lines.filter({$0.enable == true})
                completion(.success(finalLines))
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
        firebaseManager.getDocuments(type: Lines.self, forCollection: .Lines) { result in
            switch result {
            case .success(let lines):
                let finalLines = lines.filter({$0.idCity == cityId})
                completion(.success(finalLines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getLinesForCurrentCity(completion: @escaping(Result<[Lines], Error>) -> Void) {
        cityManager.getDocumentsFromCity(type: Lines.self, forCollection: .Lines) { result in
            switch result {
            case .success(let lines):
                let enabledLines = lines.filter { line in
                    return line.enable
                }
                completion(.success(enabledLines))
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
