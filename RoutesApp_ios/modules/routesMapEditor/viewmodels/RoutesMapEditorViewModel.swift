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

    func addCoordinate(coorditate: Coordinate) {
        currentLinePath?.routePoints.append(coorditate)
    }

    func convertToStop(coorditate: Coordinate) {
        currentLinePath?.stops.append(coorditate)
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
        guard let currentLinePath = currentLinePath else { return }
        let point = currentLinePath.routePoints.remove(at: oldIndex)
        currentLinePath.routePoints.insert(point, at: newIndex - 1)
    }
}
