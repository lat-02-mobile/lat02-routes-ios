//
//  CityFirebaseManager.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import Foundation

protocol CityManagerProtocol {
    func getCitiesByName(parameter: String, completion: @escaping(Result<[Cities], Error>) -> Void)
    func getCountryById(id: String, completion: @escaping(Result<Country, Error>) -> Void)
    func getCities(completion: @escaping(Result<[Cities], Error>) -> Void)
}

class CityFirebaseManager: CityManagerProtocol {
    let firebaseManager = FirebaseFirestoreManager.shared
    static let shared = CityFirebaseManager()

    func getCities(completion: @escaping (Result<[Cities], Error>) -> Void) {
        self.firebaseManager.getDocumentsWithLimit(type: Cities.self, forCollection: .Cities, limit: 10, completion: completion)
    }

    func getCitiesByName(parameter: String, completion: @escaping (Result<[Cities], Error>) -> Void) {
        self.firebaseManager.getDocumentsByParameterContains(type: Cities.self, forCollection: .Cities,
                                                             field: "name", parameter: parameter, completion: completion)
    }

    func getCountryById(id: String, completion: @escaping (Result<Country, Error>) -> Void) {
        self.firebaseManager.getSingleDocumentById(type: Country.self, forCollection: .Countries,
                                            documentID: id, completion: completion)
    }
}
