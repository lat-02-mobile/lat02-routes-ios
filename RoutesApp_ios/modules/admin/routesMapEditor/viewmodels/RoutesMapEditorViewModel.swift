//
//  RoutesMapEditorViewModel.swift
//  RoutesApp_ios
//
//  Created by user on 26/10/22.
//

import Foundation

class RoutesMapEditorViewModel: ViewModel {
    private var currentLinePath: LineRouteInfo?

    func setLinePath(linePath: LineRouteInfo) {
        currentLinePath = linePath
    }

    func getLinePath() -> LineRouteInfo? {
        return currentLinePath ?? nil
    }

    func getPointsRoutesWithType() -> [CoordinateWithType] {
        guard let linePath = currentLinePath else {
            return [CoordinateWithType]()
        }

        let pointsWithType = linePath.routePoints.map { point -> CoordinateWithType in
            var type = CoordinateType.NORMAL
            if linePath.stops.contains(point) { type = CoordinateType.STOP }
            let coords = Coordinate(latitude: point.latitude, longitude: point.longitude)
            return CoordinateWithType(point: coords, type: type)
        }
        return pointsWithType
    }

    func addCoordinate(coorditate: Coordinate) {
        currentLinePath?.routePoints.append(coorditate.toGeoCode())
    }

    func convertToStop(coorditate: Coordinate) {
        currentLinePath?.stops.append(coorditate.toGeoCode())
    }

    func removeStop(at coordinate: Coordinate) {
        guard let currentLinePath = currentLinePath else { return }

        let index = currentLinePath.stops.firstIndex(where: {$0.latitude == coordinate.latitude &&
            $0.longitude == coordinate.longitude})

        guard let index = index else { return }

        self.currentLinePath?.stops.remove(at: index)
    }

    func removeRoutePoint(at coordinate: Coordinate) {
        guard let currentLinePath = currentLinePath else { return }

        let index = currentLinePath.routePoints.firstIndex(where: {$0.latitude == coordinate.latitude &&
            $0.longitude == coordinate.longitude})

        guard let index = index else { return }

        self.currentLinePath?.routePoints.remove(at: index)
    }

    func rearrangeRoutePoint(oldIndex: Int, newIndex: Int) {
        guard var currentLinePath = currentLinePath else { return }
        let point = currentLinePath.routePoints.remove(at: oldIndex)
        currentLinePath.routePoints.insert(point, at: newIndex - 1)
    }
}
