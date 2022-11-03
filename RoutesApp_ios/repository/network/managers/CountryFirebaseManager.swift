//
//  CountryFirebaseManager.swift
//  RoutesApp_ios
//
//  Created by user on 3/11/22.
//

import Foundation

protocol CountryManagerProtocol {
    func getCountries(completion: @escaping(Result<[Country], Error>) -> Void)
}

class CountryFirebaseManager: CountryManagerProtocol {
    let firebaseManager = FirebaseFirestoreManager.shared
    static let shared = CountryFirebaseManager()

    func getCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        self.firebaseManager.getDocuments(type: Country.self, forCollection: .Countries) { result in
            switch result {
            case .success(let countries):
                completion(.success(countries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
