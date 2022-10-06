//
//  LocalDataManager.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//

import Foundation

protocol LocalDataManagerProtocol {
    func retrieveAllDataFromFirebase(completion: @escaping(Result<Void, Error>) -> Void)
}

class LocalDataManager: LocalDataManagerProtocol {
    static let shared = LocalDataManager()

    private let tourpointsManager = TourpointsManager.shared
    private let lineManager = LineFirebaseManager.shared
    private let lineRouteManager = LineRouteFirebaseManager.shared
    private let lineCategoryManager = LineCategoryFirebaseManager.shared
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.getContext()

    func retrieveAllDataFromFirebase(completion: @escaping(Result<Void, Error>) -> Void) {
        if coreDataManager.deleteAll() {
            tourpointsManager.getTourpointList { result in
                switch result {
                case.success(let tourpoints):
                    self.getAndSaveTourpointCategoriesWithTourpoints(tourpoints: tourpoints, completion: completion)
                case.failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(CoreDataError.Failed(cause: String.localizeString(localizedString: ConstantVariables.errorUpdatingData))))
        }

    }

    private func getAndSaveTourpointCategoriesWithTourpoints(tourpoints: [Tourpoint], completion: @escaping(Result<Void, Error>) -> Void) {
        let currentLocale = Locale.current.languageCode
        tourpointsManager.getTourpointCategories { result in
            switch result {
            case.success(let categories):
                for category in categories {
                    category.toEntity(context: self.coreDataManager.getContext())
                }
                let tourpointsInfo = tourpoints.compactMap({$0.toTourpointInfo(categories: categories,
                                                                               isLocationEng: currentLocale != ConstantVariables.spanishLocale)})
                for tourpoint in tourpointsInfo {
                    tourpoint.toEntity(context: self.coreDataManager.getContext())
                }
                try? self.context.save()
                self.getLineCategories(completion: completion)

            case.failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getLineCategories(completion: @escaping(Result<Void, Error>) -> Void) {
        lineCategoryManager.getCategories { result in
            switch result {
            case.success(let categories):
                for category in categories {
                    category.toEntity(context: self.coreDataManager.getContext())
                }
                self.getLines(categories: categories, completion: completion)
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getLines(categories: [LinesCategory], completion: @escaping(Result<Void, Error>) -> Void) {
        let currentLocale = Locale.current.languageCode
        lineManager.getLinesForCurrentCity { result in
            switch result {
            case.success(let lines):
                for line in lines {
                    let lineEntity = line.toEntity(categories: categories, isLocationEng: currentLocale == ConstantVariables.spanishLocale,
                                                   context: self.coreDataManager.getContext())
                    self.getLineRoutes(line: lineEntity, completion: completion)
                }
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getLineRoutes(line: LineEntity, completion: @escaping(Result<Void, Error>) -> Void) {
        lineRouteManager.getLineRoute(idLine: line.id) { result in
            switch result {
            case.success(let lineRoutes):
                let lineRouteInfo = lineRoutes.map({$0.convertToLinePath().toEntity(context: self.coreDataManager.getContext())})
                for route in lineRouteInfo {
                    route.line = line
                }
                try? self.context.save()
                completion(.success(()))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }

}
