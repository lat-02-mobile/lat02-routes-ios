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
    case LineRoute
    case LineCategories
}

class FirebaseFirestoreManager {
    static let shared = FirebaseFirestoreManager()
    let db = Firestore.firestore()
    func getDocID(forCollection collection: FirebaseCollections) -> String {
        db.collection(collection.rawValue).document().documentID
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
            guard error == nil else { return completion(.failure(error!)) }
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
            guard error == nil else { return completion(.failure(error!)) }
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

    func getDocumentsByParameterContains<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, field: String, parameter: String,
                                                       completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).whereField(field, isEqualTo: parameter).getDocuments { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
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

    func getCountryById(forCollection collection: FirebaseCollections, field: String, parameter: String, completion: @escaping ( Result<[Country], Error>) -> Void  ) {
        db.collection(collection.rawValue).whereField(field, isEqualTo: parameter).getDocuments { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            var items = [Country]()

            for document in documents {
                let id = document.get("id") as? String ?? ""
                let name = document.get("name") as? String ?? ""
                let code = document.get("code") as? String ?? ""
                let phone = document.get("phone") as? String ?? ""
                let createdAt = document.get("createdAt") as? Date ?? Date()
                let updatedAt = document.get("updatedAt") as? Date ?? Date()
                let cities = document.get("cities") as? [DocumentReference] ?? [DocumentReference]()

                let country = Country(id: id, name: name, code: code, phone: phone, createdAt: createdAt, updatedAt: updatedAt, cities: cities)
                items.append(country)
            }
            completion(.success(items))
        }
    }

    func getLines<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {

        db.collection("Lines").addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
        }
    }
    func getLineWithBooleanCondition<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, enable: Bool, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).whereField("enable", isEqualTo: enable).getDocuments { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            do {
                var objects = [T]()
                for document in snapshot.documents {
                    let decoder = Firestore.Decoder()
                    if let item = try? decoder.decode(T.self, from: document.data()) {
                        objects.append(item)
                    }
                }
                completion(.success(objects))
            }
        }
    }
    func getLineRoute<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, id: String, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).whereField("idLine", isEqualTo: id).getDocuments { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            do {
                var objects = [T]()
                for document in snapshot.documents {
                    let decoder = Firestore.Decoder()
                    if let item = try? decoder.decode(T.self, from: document.data()) {
                        objects.append(item)
                    }
                }
                completion(.success(objects))
            }
        }
    }
    func getLinesCategory<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection("LineCategories").addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }

            do {
                var objects = [T]()
                for document in snapshot.documents {
                    let decoder = Firestore.Decoder()
                    if let item = try? decoder.decode(T.self, from: document.data()) {
                        objects.append(item)
                    }
                }
                completion(.success(objects))
            }
        }
    }
}
