//
//  CityFirebaseManager.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import Foundation

protocol CityManagerProtocol {
    func getCitiesByName(parameter: String, completion: @escaping(Result<[CityRoute], Error>) -> Void)
    func getCountryById(id: String, completion: @escaping(Result<[Country], Error>) -> Void)
    func getCities(completion: @escaping(Result<[CityRoute], Error>) -> Void)
}

class CityFirebaseManager: CityManagerProtocol {
    let firebaseManager = FirebaseFirestoreManager.shared
    static let shared = CityFirebaseManager()

    func getCities(completion: @escaping (Result<[CityRoute], Error>) -> Void) {
        self.firebaseManager.getDocumentsWithLimit(type: CityRoute.self, forCollection: .CityRoute, limit: 10, completion: completion)
    }

    func getCitiesByName(parameter: String, completion: @escaping (Result<[CityRoute], Error>) -> Void) {
        self.firebaseManager.getDocumentsByParameterContains(type: CityRoute.self, forCollection: .CityRoute,
                                                             field: "name", parameter: parameter, completion: completion)
    }

    func getCountryById(id: String, completion: @escaping (Result<[Country], Error>) -> Void) {
        self.firebaseManager.getCountryById(forCollection: .Countries, field: "id",
                                            parameter: id, completion: completion)
    }
}
