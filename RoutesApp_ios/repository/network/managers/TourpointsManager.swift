//
//  TourpointsManager.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/28/22.
//

import Foundation

protocol TourpointsManagerProtocol {
    func getTourpointList(completion: @escaping (Result<[TourpointInfo], Error>) -> Void)
}

class TourpointsManager: TourpointsManagerProtocol {
    static let shared = TourpointsManager()
    let firebaseManager = FirebaseFirestoreManager.shared

    func getTourpointList(completion: @escaping (Result<[TourpointInfo], Error>) -> Void) {
        let currentLocale = Locale.current.languageCode
        firebaseManager.getTourPoints { result in
            switch result {
            case.success(let tourpoints):
                self.firebaseManager.getTourPointCategories { categories in
                    switch categories {
                    case.success(let categories):
                        let info = tourpoints.compactMap({$0.toTourpointInfo(categories: categories, isLocationEng: currentLocale != "es")})
                        completion(.success(info))
                    case.failure(let error):
                        completion(.failure(error))
                    }
                }
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }

}
