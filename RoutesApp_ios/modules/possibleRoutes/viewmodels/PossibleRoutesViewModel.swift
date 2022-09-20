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

    // swiftlint:disable function_body_length
    func getPossibleRoutes(completion: @escaping ([AvailableTransport]) -> Void) {
        let stops1Array = [
            Coordinate(latitude: -16.52130602845841, longitude: -68.12417648825397),
            Coordinate(latitude: -16.521670987319112, longitude: -68.12320625310048),
            Coordinate(latitude: -16.522451435494332, longitude: -68.12218135682076),
            Coordinate(latitude: -16.523780248849537, longitude: -68.12235510114752),
            Coordinate(latitude: -16.524285569842718, longitude: -68.12298370418992)
         ]

        let points1Array = [
            Coordinate(latitude: -16.520939322501413, longitude: -68.12557074070023),
            Coordinate(latitude: -16.521062847351256, longitude: -68.12514516472181),
            Coordinate(latitude: -16.52130602845841, longitude: -68.12417648825397),
            Coordinate(latitude: -16.521670987319112, longitude: -68.12320625310048),
            Coordinate(latitude: -16.52197231180913, longitude: -68.12260107624422),
            Coordinate(latitude: -16.522451435494332, longitude: -68.12218135682076),
            Coordinate(latitude: -16.523261825566387, longitude: -68.12214426533951),
            Coordinate(latitude: -16.523703514803486, longitude: -68.1221403609752),
            Coordinate(latitude: -16.523780248849537, longitude: -68.12235510114752),
            Coordinate(latitude: -16.524002964559173, longitude: -68.12266159393164),
            Coordinate(latitude: -16.524285569842718, longitude: -68.12298370418992)
         ]

        let points2Array = [
            Coordinate(latitude: -16.5255314, longitude: -68.1254204),
            Coordinate(latitude: -16.5247497, longitude: -68.1251629),
            Coordinate(latitude: -16.5247755, longitude: -68.1246533),
            Coordinate(latitude: -16.5251612, longitude: -68.1243314),
            Coordinate(latitude: -16.5251046, longitude: -68.1238218),
            Coordinate(latitude: -16.5246006, longitude: -68.1232156),
            Coordinate(latitude: -16.5245543, longitude: -68.1218155),
            Coordinate(latitude: -16.5247286, longitude: -68.1216115),
            Coordinate(latitude: -16.5241937, longitude: -68.1204527)
         ]

        let stops2Array = [
            Coordinate(latitude: -16.5255314, longitude: -68.1254204),
            Coordinate(latitude: -16.5246006, longitude: -68.1232156),
            Coordinate(latitude: -16.5241937, longitude: -68.1204527)
         ]

        // MARK: Route 1
        let routePoints1 = points1Array
        let stops1 = stops1Array
        let line1 = Line(name: "01", categoryRef: "LineCategories/DW8blCpvs0OXwkozaEhn",
                     routePoints: routePoints1, start: routePoints1[0], stops: stops1, averageVelocity: 20.5)
        // MARK: Route 2
        let routePoints2 = points2Array
        let stops2 = stops2Array
        let line2 = Line(name: "1001", categoryRef: "LineCategories/JY8blWsvs0OXwkozaJlb",
                     routePoints: routePoints2, start: routePoints2[0], stops: stops2, averageVelocity: 30.2)

        let originPoint = Coordinate(latitude: -16.52153, longitude: -68.12278).toCLLocationCoordinate2D()
        let destinationPoint = Coordinate(latitude: -16.52423, longitude: -68.1203).toCLLocationCoordinate2D()
        let minDistance = 200.0
        let minDistanceBtwStops = 200.0

        let result = Algorithm.shared.findAvailableRoutes(origin: originPoint, destination: destinationPoint,
            lines: [line1, line2], minDistanceBtwPoints: minDistance, minDistanceBtwStops: minDistanceBtwStops)
        completion(result)
    }
}
