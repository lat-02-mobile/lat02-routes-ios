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

    /* func getPossibleRoutes(completion: @escaping ([AvailableTransport]) -> Void) {
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

        let categories = [
            LinesCategory(id: "1", nameEng: "Cableway", nameEsp: "Teleférico",
                  blackIcon: "https://firebasestorage.googleapis.com/v0/b/routes-app-8c8e4.appspot.com/o/lineCategories%2Fcable_way_black.png?alt=media&token=d43f6279-265c-4a56-bf61-6579c2e9c391",
                  whiteIcon: "https://firebasestorage.googleapis.com/v0/b/routes-app-8c8e4.appspot.com/o/lineCategories%2Fcable_way_white.png?alt=media&token=98c4cf19-fb19-40a2-af4c-8f4e67b0f5f5"),
            LinesCategory(id: "2", nameEng: "Subway", nameEsp: "Tren",
                  blackIcon: "https://firebasestorage.googleapis.com/v0/b/routes-app-8c8e4.appspot.com/o/lineCategories%2Fsubway_black.png?alt=media&token=7f8c755c-da68-4b85-8bc1-1df26ecb92d8",
                  whiteIcon: "https://firebasestorage.googleapis.com/v0/b/routes-app-8c8e4.appspot.com/o/lineCategories%2Fsubway_white.png?alt=media&token=c3fe8f8e-7696-4879-b042-52e710f94842"),
            LinesCategory(id: "3", nameEng: "Bus", nameEsp: "Bus",
                  blackIcon: "https://firebasestorage.googleapis.com/v0/b/routes-app-8c8e4.appspot.com/o/lineCategories%2Fbus_black.png?alt=media&token=21c3ba52-27ed-499a-933a-a31c8f2062ba",
                  whiteIcon: "https://firebasestorage.googleapis.com/v0/b/routes-app-8c8e4.appspot.com/o/lineCategories%2Fbus_white.png?alt=media&token=980b407c-2fc7-4fd2-b8da-a5504a7c7f1c")
        ]
        // MARK: Route 1
        let routePoints1 = points1Array
        let stops1 = stops1Array
        let line1 = LineRoute(name: "01", id: "01", idLine: "Zy8i3x4nQH0os7TaCizc", line: "Lines/4MhlK4IGLhTL6wcf50xk",
                              routePoints: routePoints1, start: routePoints1[0], stops: stops1, end: routePoints1.last!, averageVelocity: 2.3
                              ,
              blackIcon: categories[0].blackIcon!, whiteIcon: categories[0].whiteIcon!, color: "#67F5ED")
        // MARK: Route 2
        let routePoints2 = points2Array
        let stops2 = stops2Array
        let line2 = LineRoute(name: "1001", id: "01", idLine: "Zy8i3x4nQH0os7TaCizc", line: "Lines/4MhlK4IGLhTL6wcf50xk",
              routePoints: routePoints2, start: routePoints2[0], stops: stops2, end: routePoints2.last!, averageVelocity: 3.2,
              blackIcon: categories[2].blackIcon!, whiteIcon: categories[2].whiteIcon!, color: "#6495ED")

        let originPoint = Coordinate(latitude: -16.52153, longitude: -68.12278).toCLLocationCoordinate2D()
        let destinationPoint = Coordinate(latitude: -16.52423, longitude: -68.1203).toCLLocationCoordinate2D()
        let minDistance = 200.0
        let minDistanceBtwStops = 200.0

        let result = Algorithm.shared.findAvailableRoutes(origin: originPoint, destination: destinationPoint,
            lines: [line1, line2], minDistanceBtwPoints: minDistance, minDistanceBtwStops: minDistanceBtwStops)
        completion(result)
    } */
}
