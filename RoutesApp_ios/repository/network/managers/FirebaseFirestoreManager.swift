//
//  FirebaseFirestoreManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 3/8/22.
//

import Foundation
import FirebaseFirestore

enum FirebaseErrors: Error {
    case ErrorToDecodeItem
    case InvalidUser
    case DocumentNotFound
}

enum FirebaseCollections: String {
    case Users
    case Countries
    case Cities
    case Lines
    case LineCategories
    case Tourpoints
    case TourpointsCategory
    case LineRoute
}

class FirebaseFirestoreManager {
    static let shared = FirebaseFirestoreManager()
    let db = Firestore.firestore()
    func getDocID(forCollection collection: FirebaseCollections) -> String {
        db.collection(collection.rawValue).document().documentID
    }

    func getDocReference(forCollection collection: FirebaseCollections, documentID: String) -> DocumentReference {
        db.collection(collection.rawValue).document(documentID)
    }
    func addDocument<T: Encodable & BaseModel>(document: T, collection: FirebaseCollections, completion: @escaping ( Result<T, Error>) -> Void  ) {
        guard let itemDict = document.dict else { return completion(.failure(FirebaseErrors.ErrorToDecodeItem)) }
        db.collection(collection.rawValue).document(document.id).setData(itemDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(document))
            }
        }
    }
    func getDocuments<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).getDocuments { querySnapshot, error in
            if let err = error {
                return completion(.failure(err))
            }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            let finalDocuments = documents.compactMap({try?$0.data(as: type)})
            completion(.success(finalDocuments))

        }
    }
    func getDocumentsAsync<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections) async throws -> [T] {
        do {
            let querySnapshot = try await db.collection(collection.rawValue).getDocuments()
            let documents = querySnapshot.documents
            var items = [T]()
            let decoder = Firestore.Decoder()
            for document in documents {
                let item = try decoder.decode(T.self, from: document.data())
                items.append(item)
            }
            return items
        } catch let error {
            throw error
        }
    }

    func getDocumentByIdAsync<T: Decodable>(docId: String, type: T.Type, forCollection collection: FirebaseCollections) async throws -> T {
        do {
            let querySnapshot = try await db.collection(collection.rawValue).whereField("id", isEqualTo: docId).getDocuments()
            let decoder = Firestore.Decoder()
            if let document = querySnapshot.documents.first {
                return try decoder.decode(T.self, from: document.data())
            }
            throw FirebaseErrors.DocumentNotFound
        } catch let error {
            throw error
        }
    }

    func getDocumentsWithLimit<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, limit: Int, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).limit(to: limit).getDocuments { querySnapshot, error in
            if let err = error {
                return completion(.failure(err))
            }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            var items = [T]()
            let json = JSONDecoder()
            for document in documents {
                if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let item = try? json.decode(type, from: data) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }
    }

    func getDocumentsByParameterContains<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, field: String, parameter: Any,
                                                       completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).whereField(field, isEqualTo: parameter).getDocuments { querySnapshot, error in
            if let err = error {
                return completion(.failure(err))
            }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            let finalDocuments = documents.compactMap({try?$0.data(as: type)})
            completion(.success(finalDocuments))
        }
    }
    func getDocumentsByDateGreaterThanOrEquelTo<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, field: String, date: Date,
                                                              completion: @escaping ( Result<[T], Error>) -> Void  ) {
            db.collection(collection.rawValue).whereField(field, isGreaterThanOrEqualTo: date).getDocuments { querySnapshot, error in
            if let err = error {
                return completion(.failure(err))
            }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            let finalDocuments = documents.compactMap({try?$0.data(as: type)})
            completion(.success(finalDocuments))
        }
    }

    func getDocumentsByParameterContainsDateGreaterThanOrEqualTo<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, field: String, fieldDate: String,
                                                                               date: Date, parameter: Any,
                                                                               completion: @escaping ( Result<[T], Error>) -> Void  ) {
            db.collection(collection.rawValue).whereField(field, isEqualTo: parameter).whereField(fieldDate, isGreaterThanOrEqualTo: date)
                                                                                      .getDocuments { querySnapshot, error in
            if let err = error {
                return completion(.failure(err))
            }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            let finalDocuments = documents.compactMap({try?$0.data(as: type)})
            completion(.success(finalDocuments))
        }
    }

    func getDocumentsByParameterContainsAsync<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, field: String, parameter: String) async throws -> [T] {
        do {
            let querySnapshot = try await db.collection(collection.rawValue).whereField(field, isEqualTo: parameter).getDocuments()
            let documents = querySnapshot.documents
            var items = [T]()
            let decoder = Firestore.Decoder()
            for document in documents {
                let item = try decoder.decode(T.self, from: document.data())
                items.append(item)
            }
            return items
        } catch let error {
            throw error
        }
    }

    func getSingleDocumentById<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, documentID: String, completion: @escaping ( Result<T, Error>) -> Void  ) {
        db.collection(collection.rawValue).document(documentID).getDocument { querySnapshot, error in
            if let err = error {
                return completion(.failure(err))
            }
            do {
                guard let snap = querySnapshot, let document = try snap.data(as: type) else { return }
                completion(.success(document))
            } catch {
                completion(.failure(FirebaseErrors.ErrorToDecodeItem))
            }
        }
    }

    func updateDocument<T: Codable & BaseModel>(document: T, collection: FirebaseCollections, completion: @escaping ( Result<T, Error>) -> Void  ) {
        do {
            let item = try? Firestore.Encoder().encode(document)
            guard let itemDict = item else { return completion(.failure(FirebaseErrors.ErrorToDecodeItem)) }
            db.collection(collection.rawValue).document(document.id).setData(itemDict) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(document))
                }
            }
        } catch {
            completion(.failure(FirebaseErrors.ErrorToDecodeItem))
        }
    }
}
