//
//  PossibleRoutesViewModel.swift
//  RoutesApp_ios
//
//  Created by user on 19/9/22.
//

import Foundation
import GoogleMaps
import CoreLocation

class PossibleRoutesViewModel: ViewModel {
    var map: GMSMapView?
    var possibleRoutes: [AvailableTransport] = []
    var possibleRoutesSelectedIndex = -1
    var onFinishGetDirections: (() -> Void)?

    var googleMapsManager: GoogleMapsManagerProtocol = GoogleMapsManager.shared

    func getDirections(origin: Coordinate, destination: Coordinate, completion: @escaping (GMSPath) -> Void) {
        googleMapsManager.getDirections(origin: origin, destination: destination) { result in
            switch result {
            case.success(let directions):
                let path = GMSPath.init(fromEncodedPath:
                                            directions.routes.first?.overviewPolyline.points ?? "")
                guard let coordList = path else { return }
                self.onFinish?()
                completion(coordList)
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func getSelectedRoute() -> AvailableTransport {
        return possibleRoutes[possibleRoutesSelectedIndex]
    }

    func sortPossibleRoutes() {
        possibleRoutes.sort(by: { routeA, routeB  in
            routeA.calculateTotalDistance() < routeB.calculateTotalDistance()
        })
    }
}
