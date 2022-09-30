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

class HomeViewModel {
    var currentPosition: CLLocationCoordinate2D?
    var origin: GMSMarker?
    var destination: GMSMarker?
    var pointsSelectionStatus = PointsSelectionStatus.pendingOrigin
    var routeListManager: RouteListManagerProtocol = RouteListManager.shared
    var lineManager = LineFirebaseManager.shared
    var lineRoutes: [LineRoute] = [] {
        didSet {
            runAlgorithm?()
        }
    }
    var runAlgorithm: (() -> Void)?

    func getLineRouteForCurrentCity() async throws {
        guard let currentCityId = ConstantVariables.defaults.string(forKey: ConstantVariables.defCityId) else { return }
        do {
            let linesByCity = try await lineManager.getLinesByCityAsync(cityId: currentCityId)
            var finalLineRoutes = [LineRouteInfo]()
            print("Here are the lines: \(linesByCity.count)" )
            for line in linesByCity {
                let lineRoutes = try await routeListManager.getLinesRoutesByLineAsync(idLine: line.id)
                finalLineRoutes.append(contentsOf: lineRoutes)
            }
            print("Here are the lineRoutes: \(finalLineRoutes.count)")
            self.lineRoutes = try await parseLineRouteInfoToLineRoutes(lineRoutesInfo: finalLineRoutes)
        } catch let error {
           throw error
        }
    }

    private func parseLineRouteInfoToLineRoutes(lineRoutesInfo: [LineRouteInfo]) async throws -> [LineRoute] {
        var finalLineRoutes = [LineRoute]()
        do {
            for lineRouteInfo in lineRoutesInfo {
                try await finalLineRoutes.append(lineRouteInfo.toLineRoute())
            }
            return finalLineRoutes
        } catch let error {
            print("errorroror: \(error)")
            throw error
        }
    }
}
