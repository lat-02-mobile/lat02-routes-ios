//
//  Algorithm.swift
//  RoutesApp_ios
//
//  Created by user on 29/8/22.
//

import Foundation
import CoreLocation

class Algorithm {
    static var shared = Algorithm()

    func findAvailableRoutes(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D,
                             lines: [Line], minDistanceBtwPoints: Double, minDistanceBtwStops: Double) -> [AvailableTransport] {
        var availableTransports = [AvailableTransport]()
        // MARK: Add route candidates
        let originCandidates = getOriginRoutes(origin: origin, lines: lines,
           minDistanceBtwStops: minDistanceBtwStops)
        let destinationCandidates = getDestinationRoutes(destination: destination,
             lines: lines, minDistanceBtwStops: minDistanceBtwStops)
        // MARK: Add one line routes
        let oneRouteLines = getOneRouteLines(origin: origin, destination: destination,
             lines: lines, minDistanceBtwStops: minDistanceBtwStops)
        availableTransports.insert(contentsOf: oneRouteLines, at: 0)
        let candidates = LinesCandidate(originList: originCandidates, destinationList: destinationCandidates)
        // MARK: Add the combined routes
        let combinedAvailableTransports = getCombinedRoutes(origin: origin, destination: destination,
            candidates: candidates, minDistanceBtwPoints: minDistanceBtwPoints,
            minDistanceBtwStops: minDistanceBtwStops)
        availableTransports.insert(contentsOf: combinedAvailableTransports, at: 0)

        return availableTransports
    }

    private func getOneRouteLines(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D,
                                  lines: [Line], minDistanceBtwStops: Double) -> [AvailableTransport] {
        var availableTransports = [AvailableTransport]()
        for line in lines {
            let nearestStopToOrigin = line.stops.min(by: {
                $0.toCLLocationCoordinate2D().distance(to: origin) <= $1.toCLLocationCoordinate2D().distance(to: origin)
            })

            let nearestStopToDestination = line.stops.min(by: {
                $0.toCLLocationCoordinate2D().distance(to: destination) <= $1.toCLLocationCoordinate2D().distance(to: destination)
            })

            if let nearestStopToDestination = nearestStopToDestination,
               let nearestStopToOrigin = nearestStopToOrigin,
               isInDelimitedArea(coordinateA: nearestStopToDestination, coordinateB: destination.toCoordinate(), distance: minDistanceBtwStops),
               isInDelimitedArea(coordinateA: nearestStopToOrigin, coordinateB: origin.toCoordinate(), distance: minDistanceBtwStops) {
                let newLine = line.slice(from: nearestStopToOrigin, till: nearestStopToDestination)
                availableTransports.append(AvailableTransport(connectionPoint: nil, transports: [newLine]))
            }
        }
        return availableTransports
    }

    private func getOriginRoutes(origin: CLLocationCoordinate2D, lines: [Line], minDistanceBtwStops: Double) -> [Line] {
        var originRoutes = [Line]()
        for line in lines {
            let nearestStopToOrigin = line.stops.min(by: {
                $0.toCLLocationCoordinate2D().distance(to: origin) < $1.toCLLocationCoordinate2D().distance(to: origin)
            })

            if let nearestStopToOrigin = nearestStopToOrigin,
               isInDelimitedArea(coordinateA: nearestStopToOrigin, coordinateB: origin.toCoordinate(), distance: minDistanceBtwStops) {
                let newLine = line.slice(from: nearestStopToOrigin)
                originRoutes.append(newLine)
            }
        }
        return originRoutes
    }

    private func getDestinationRoutes(destination: CLLocationCoordinate2D, lines: [Line], minDistanceBtwStops: Double) -> [Line] {
        var destinationRoutes = [Line]()
        for line in lines {
            let nearestStopToDestination = line.stops.min(by: {
                $0.toCLLocationCoordinate2D().distance(to: destination) < $1.toCLLocationCoordinate2D().distance(to: destination)
            })

            if let nearestStopToDestination = nearestStopToDestination,
               isInDelimitedArea(coordinateA: nearestStopToDestination, coordinateB: destination.toCoordinate(), distance: minDistanceBtwStops) {
                let newLine = line.slice(till: nearestStopToDestination)
                destinationRoutes.append(newLine)
            }
        }
        return destinationRoutes
    }

    private func getCombinedRoutes(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D,
                                   candidates: LinesCandidate, minDistanceBtwPoints: Double, minDistanceBtwStops: Double) -> [AvailableTransport] {
        var availableTransports: [AvailableTransport] = []
        for routeFromOrigin in candidates.originList {
            for routeFromDestination in candidates.destinationList {
                if routeFromOrigin == routeFromDestination { continue }
                for stop in routeFromDestination.stops {
                    let nearestStopToOrigin = routeFromOrigin.stops.min(by: {
                        $0.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D()) <=
                            $1.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D())
                    })
                    guard let nearestStopToOrigin = nearestStopToOrigin else { continue }
                    if isInDelimitedArea(coordinateA: nearestStopToOrigin, coordinateB: stop, distance: minDistanceBtwStops) {
                        let connectionPoint = getIndexWhere(coordinate: nearestStopToOrigin, coordinateList: routeFromOrigin.stops)
                        // MARK: Origin line splice
                        let newOriginLine = routeFromOrigin.slice(till: nearestStopToOrigin)
                        // MARK: Destination line splice
                        let newDestinationLine = routeFromOrigin.slice(from: nearestStopToOrigin)
                        // MARK: Add the combined transportation
                        availableTransports.append(AvailableTransport(connectionPoint: connectionPoint,
                              transports: [newOriginLine, newDestinationLine]))
                    }
                }
            }
        }
        return availableTransports
    }

    func isInDelimitedArea(coordinateA: Coordinate, coordinateB: Coordinate, distance: Double) -> Bool {
        return coordinateA.toCLLocationCoordinate2D().distance(to: coordinateB.toCLLocationCoordinate2D()) <= distance
    }

    private func getIndexWhere(coordinate: Coordinate, coordinateList: [Coordinate]) -> Int {
        return coordinateList.firstIndex(where: { $0 == coordinate }) ?? -1
    }
}
