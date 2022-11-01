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
}
