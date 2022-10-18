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
    var selectedAvailableTransport: AvailableTransport?
    var currentPosition: CLLocationCoordinate2D?
    var origin: GMSMarker?
    var destination: GMSMarker?
    var pointsSelectionStatus = PointsSelectionStatus.pendingOrigin
    var lineRouteManager: LineRouteManagerProtocol = LineRouteFirebaseManager.shared
    var lineManager: LineManagerProtocol = LineFirebaseManager.shared
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
            for line in linesByCity {
                let lineRoutes = try await lineRouteManager.getLinesRoutesByLineAsync(idLine: line.id)
                finalLineRoutes.append(contentsOf: lineRoutes)
            }
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
            throw error
        }
    }
}
