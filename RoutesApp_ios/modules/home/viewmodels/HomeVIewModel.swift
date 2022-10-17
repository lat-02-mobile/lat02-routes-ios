//
//  HomeVIewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 10/8/22.
//

import Foundation
import CoreLocation
import GoogleMaps

enum PointsSelectionStatus {
case pendingOrigin, pendingDestination, bothSelected
}

class HomeViewModel: ViewModel {
    var selectedAvailableTransport: AvailableTransport?
    var currentPosition: CLLocationCoordinate2D?
    var origin: GMSMarker?
    var destination: GMSMarker?
    var pointsSelectionStatus = PointsSelectionStatus.pendingOrigin
    var localDataManager: LocalDataManagerProtocol = LocalDataManager.shared
    var lineManager: LineManagerProtocol = LineFirebaseManager.shared
    var lineRoutes: [LineRoute] = [] {
        didSet {
            runAlgorithm?()
        }
    }
    var runAlgorithm: (() -> Void)?

    func getLineRouteForCurrentCity() {
        localDataManager.getDataFromCoreData(type: LineEntity.self, forEntity: LineEntity.name) { result in
            switch result {
            case.success(let lines):
                self.lineRoutes = LineEntityConverterHelper.shared.convertLinesToLineRoutes(lines: lines)
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
