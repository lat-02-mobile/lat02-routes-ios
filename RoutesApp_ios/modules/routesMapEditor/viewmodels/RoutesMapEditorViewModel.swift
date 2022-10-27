//
//  RoutesMapEditorViewModel.swift
//  RoutesApp_ios
//
//  Created by user on 26/10/22.
//

import Foundation

class RoutesMapEditorViewModel: ViewModel {
    private var currentLinePath: LineRouteEntity?

    func setLinePath(linePath: LineRouteEntity) {
        currentLinePath =  linePath
    }

    func getLinePath() -> LineRouteEntity {
        return currentLinePath ?? LineRouteEntity()
    }

    func getPointsRoutesWithType() -> [CoordinateWithType] {
        guard let linePath = currentLinePath else {
            return [CoordinateWithType]()
        }

        let pointsWithType = linePath.routePoints.map { point -> CoordinateWithType in
            var type = CoordinateType.NORMAL
            if linePath.stops.contains(point) { type = CoordinateType.STOP }
            return CoordinateWithType(point: point, type: type)
        }
        return pointsWithType
    }
}
