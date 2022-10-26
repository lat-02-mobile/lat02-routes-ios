//
//  LineFirebaseManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 29/9/22.
//

import Foundation
import Firebase

protocol LineManagerProtocol {
    func createNewLine(newLineName: String, idCategory: String, idCity: String, completion: @escaping(Result<Lines, Error>) -> Void)
    func getAllLines(completion: @escaping(Result<[Lines], Error>) -> Void)
    func getEnabledLines(completion: @escaping(Result<[Lines], Error>) -> Void)
    func getLineByIdAsync(lineId: String) async throws -> Lines
    func getLinesByCity(cityId: String, completion: @escaping(Result<[Lines], Error>) -> Void)
    func getLinesByCityAsync(cityId: String) async throws -> [Lines]
    func getLinesForCurrentCity(completion: @escaping(Result<[Lines], Error>) -> Void)
    func updateLine(line: Lines, newLineName: String,
                    newIdCategory: String, newIdCity: String,
                    newEnable: Bool, completion: @escaping(Result<Bool, Error>) -> Void)
    func deleteLine(idLine: String, completion: @escaping(Result<Bool, Error>) -> Void)
}

class LineFirebaseManager: LineManagerProtocol {
    let firebaseManager = FirebaseFirestoreManager.shared
    let lineRouteFirebaseManager: LineRouteManagerProtocol = LineRouteFirebaseManager()
    static let shared = LineFirebaseManager()
    let cityManager = CityFirebaseManager.shared

    func createNewLine(newLineName: String, idCategory: String, idCity: String, completion: @escaping(Result<Lines, Error>) -> Void) {
        let newLineId = firebaseManager.getDocID(forCollection: .Lines)
        guard !idCategory.isEmpty else {return}
        let newLine = Lines(categoryRef: firebaseManager.getDocReference(forCollection: .LineCategories, documentID: idCategory),
                            enable: false,
                            id: newLineId,
                            idCity: idCity,
                            idCategory: idCategory,
                            name: newLineName,
                            updateAt: Timestamp(),
                            createAt: Timestamp()
        )
        firebaseManager.addDocument(document: newLine, collection: .Lines) { result in
            switch result {
            case .success(let status):
                completion(.success(status))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getAllLines(completion: @escaping(Result<[Lines], Error>) -> Void) {
        firebaseManager.getDocuments(type: Lines.self, forCollection: .Lines) { result in
            switch result {
            case .success(let lines):
                completion(.success(lines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getEnabledLines(completion: @escaping(Result<[Lines], Error>) -> Void) {
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
    func getLinesForCurrentCityByDateGreaterThanOrEqualTo(date: Date, completion: @escaping(Result<[Lines], Error>) -> Void) {
        cityManager.getDocumentsFromCityByDateGreaterThanOrEqualTo(type: Lines.self, forCollection: .Lines, date: date) { result in
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

    func updateLine(line: Lines, newLineName: String,
                    newIdCategory: String, newIdCity: String,
                    newEnable: Bool, completion: @escaping(Result<Bool, Error>) -> Void) {
        let newLine = Lines(categoryRef: firebaseManager.getDocReference(forCollection: .LineCategories, documentID: newIdCategory),
                            enable: newEnable,
                            id: line.id,
                            idCity: newIdCity,
                            idCategory: newIdCategory,
                            name: newLineName,
                            updateAt: Timestamp(),
                            createAt: line.createAt
        )
        firebaseManager.updateDocument(document: newLine, forCollection: .Lines) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteLine(idLine: String, completion: @escaping(Result<Bool, Error>) -> Void) {
        lineRouteFirebaseManager.getLineRoutesByLine(idLine: idLine) { result in
            switch result {
            case .success(let lineRoutes):
                if !lineRoutes.isEmpty {
                    completion(.success(false))
                } else {
                    self.firebaseManager.deleteDocument(type: Lines.self, forCollection: .Lines, documentID: idLine) { delResult in
                        switch delResult {
                        case .success:
                            completion(.success(true))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
