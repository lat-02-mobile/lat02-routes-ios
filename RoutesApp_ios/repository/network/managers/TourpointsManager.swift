//
//  TourpointsManager.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/28/22.
//

import Foundation

protocol TourpointsManagerProtocol {
    func getTourpointList(completion: @escaping (Result<[Tourpoint], Error>) -> Void)
    func getTourpointCategories(completion: @escaping (Result<[TourpointCategory], Error>) -> Void)
    func getTourpointCategoriesByDate(date: Date, completion: @escaping (Result<[TourpointCategory], Error>) -> Void)
}

class TourpointsManager: TourpointsManagerProtocol {
    static let shared = TourpointsManager()
    let firebaseManager = FirebaseFirestoreManager.shared
    let cityManager = CityFirebaseManager.shared

    func getTourpointList(completion: @escaping (Result<[Tourpoint], Error>) -> Void) {
        cityManager.getDocumentsFromCity(type: Tourpoint.self, forCollection: .Tourpoints, usingReference: true) { result in
            switch result {
            case.success(let tourpoints):
                completion(.success(tourpoints))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getTourpointCategories(completion: @escaping (Result<[TourpointCategory], Error>) -> Void) {
        firebaseManager.getDocuments(type: TourpointCategory.self, forCollection: .TourpointsCategory, completion: completion)
    }
    func getTourpointCategoriesByDate(date: Date, completion: @escaping (Result<[TourpointCategory], Error>) -> Void) {
        firebaseManager.getDocumentsByDate(type: TourpointCategory.self, forCollection: .TourpointsCategory, field: "updateAt",
                                           date: date, completion: completion)
    }

}
