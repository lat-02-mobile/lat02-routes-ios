//
//  LineRouteEditModeViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 31/10/22.
//

import Foundation
import FirebaseFirestore

class LineRouteEditModeViewModel: ViewModel {
    var currLine: Lines?
    var lineRouteManager: LineRouteManagerProtocol = LineRouteFirebaseManager()
    var cityManager: CityManagerProtocol = CityFirebaseManager()
    var cityCoords: Coordinate?
    var onFinishGetCityCoords: (() -> Void)?

    func createLineRoute(name: String, avgVel: String, color: String, start: GeoPoint, end: GeoPoint,
                         routePoints: [GeoPoint], stops: [GeoPoint]) {
        guard !name.isEmpty, !avgVel.isEmpty else {
            self.onError?(String.localizeString(localizedString: StringResources.adminSomeFieldsEmpty))
            return
        }
        lineRouteManager.createNewLineRoute(idLine: currLine?.id ?? "",
                                            lineRouteName: name, avgVel: avgVel,
                                            color: color, start: start, end: end,
                                            routePoints: routePoints, stops: stops) { result in
            switch result {
            case .success:
                self.onFinish?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func editLineRoute(targetLineRoute: LineRouteInfo, newName: String, newAvgVel: String, newColor: String,
                       newRoutePoitns: [GeoPoint], newStops: [GeoPoint], newStart: GeoPoint, newEnd: GeoPoint) {
        guard !newName.isEmpty, !newAvgVel.isEmpty else {
            self.onError?(String.localizeString(localizedString: StringResources.adminSomeFieldsEmpty))
            return
        }
        lineRouteManager.updateLineRoute(lineRoute: targetLineRoute, newLineRouteName: newName, newAvgVel: newAvgVel,
                                         newColor: newColor, newRoutePoints: newRoutePoitns, newStops: newStops,
                                         newStart: newStart, newEnd: newEnd) { result in
            switch result {
            case .success(let status):
                if status {
                    self.onFinish?()
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func deleteLineRoute(idLineRoute: String) {
        lineRouteManager.deleteLineRoute(idLineRoute: idLineRoute) { result in
            switch result {
            case .success(let status):
                if status {
                    self.onFinish?()
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func getCityCoords() {
        guard let idCity = currLine?.idCity else {return}
        cityManager.getCityById(id: idCity) { result in
            switch result {
            case .success(let city):
                guard let latitude = Double(city.lat),
                      let longitude = Double(city.lng) else {return}
                self.cityCoords = Coordinate(latitude: latitude, longitude: longitude)
                self.onFinishGetCityCoords?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
