//
//  CitySplashViewModel.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//

import Foundation
import CoreData

class CitySplashViewModel: ViewModel {
    static let shared = CitySplashViewModel()

    let authManager: AuthProtocol = FirebaseAuthManager.shared
    private let tourpointsManager = TourpointsManager.shared
    private let routelistManager = RouteListManager.shared
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.getContext()

    func retrieveAllDataFromFirebase() {
        if coreDataManager.deleteAll() {
            tourpointsManager.getTourpointList { result in
                switch result {
                case.success(let tourpoints):
                    self.getAndSaveTourpointCategoriesWithTourpoints(tourpoints: tourpoints)
                case.failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        } else {
            self.onError?(String.localizeString(localizedString: ConstantVariables.errorUpdatingData))
        }

    }

    private func getAndSaveTourpointCategoriesWithTourpoints(tourpoints: [Tourpoint]) {
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
                self.getLineCategories()

            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    private func getLineCategories() {
        routelistManager.getCategories { result in
            switch result {
            case.success(let categories):
                for category in categories {
                    category.toEntity(context: self.coreDataManager.getContext())
                }
                self.getLines(categories: categories)
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    private func getLines(categories: [LinesCategory]) {
        let currentLocale = Locale.current.languageCode
        routelistManager.getLines { result in
            switch result {
            case.success(let lines):
                for line in lines {
                    let lineEntity = line.toEntity(categories: categories, isLocationEng: currentLocale == ConstantVariables.spanishLocale,
                                                   context: self.coreDataManager.getContext())
                    self.getLineRoutes(line: lineEntity)
                }
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    private func getLineRoutes(line: LineEntity) {
        routelistManager.getLineRoute(idLine: line.id) { result in
            switch result {
            case.success(let lineRoutes):
                let lineRouteInfo = lineRoutes.map({$0.convertToLinePath().toEntity(context: self.coreDataManager.getContext())})
                for route in lineRouteInfo {
                    route.line = line
                }
                try? self.context.save()
                self.onFinish?()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
