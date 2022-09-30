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
    static var minDistanceBtwPointsAndStops = 200.0

    func findAvailableRoutes(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D,
                             lines: [LineRoute], minDistanceBtwPoints: Double, minDistanceBtwStops: Double) -> [AvailableTransport] {
        var availableTransports = [AvailableTransport]()
        var originCandidates = [LineRoute]()
        var destinationCandidates = [LineRoute]()
        for line in lines {
            // MARK: Add origin line candidate
            let originLineCandidate = getOriginRouteLine(origin: origin, line: line,
                                                      minDistanceBtwStops: minDistanceBtwStops)
            if let originLineCandidate = originLineCandidate {
                originCandidates.append(originLineCandidate)
            }
            // MARK: Add route candidate
            let destinationLineCandidate = getDestinationRouteLine(destination: destination,
                 line: line, minDistanceBtwStops: minDistanceBtwStops)
            if let destinationLineCandidate = destinationLineCandidate {
                destinationCandidates.append(destinationLineCandidate)
            }
            // MARK: Add one line routes
            let oneLineRoute = getOneRouteLine(origin: origin, destination: destination,
                 line: line, minDistanceBtwStops: minDistanceBtwStops)
            if let oneLineRoute = oneLineRoute {
                availableTransports.append(oneLineRoute)
            }
        }
        let candidates = LinesCandidate(originList: originCandidates, destinationList: destinationCandidates)
        // MARK: Add the combined routes
        let combinedAvailableTransports = getCombinedRouteLines(origin: origin, destination: destination,
            candidates: candidates, minDistanceBtwPoints: minDistanceBtwPoints,
            minDistanceBtwStops: minDistanceBtwStops)
        availableTransports.insert(contentsOf: combinedAvailableTransports, at: 0)

        return availableTransports
    }

    private func getOneRouteLine(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D,
                                 line: LineRoute, minDistanceBtwStops: Double) -> AvailableTransport? {
        let nearestStopToOrigin = line.stops.min(by: {
            $0.toCLLocationCoordinate2D().distance(to: origin) <= $1.toCLLocationCoordinate2D().distance(to: origin)
        })

        let nearestStopToDestination = line.stops.min(by: {
            $0.toCLLocationCoordinate2D().distance(to: destination) <= $1.toCLLocationCoordinate2D().distance(to: destination)
        })

        guard let nearestStopToDestination = nearestStopToDestination,
           let nearestStopToOrigin = nearestStopToOrigin,
           isInDelimitedArea(coordinateA: nearestStopToDestination, coordinateB: destination.toCoordinate(), distance: minDistanceBtwStops),
           isInDelimitedArea(coordinateA: nearestStopToOrigin, coordinateB: origin.toCoordinate(), distance: minDistanceBtwStops) else { return nil }
        let newLine = line.slice(from: nearestStopToOrigin, till: nearestStopToDestination)
        return AvailableTransport(connectionPoint: nil, transports: [newLine])
    }

    private func getOriginRouteLine(origin: CLLocationCoordinate2D, line: LineRoute, minDistanceBtwStops: Double) -> LineRoute? {
        let nearestStopToOrigin = line.stops.min(by: {
            $0.toCLLocationCoordinate2D().distance(to: origin) < $1.toCLLocationCoordinate2D().distance(to: origin)
        })

        guard let nearestStopToOrigin = nearestStopToOrigin,
           isInDelimitedArea(coordinateA: nearestStopToOrigin, coordinateB: origin.toCoordinate(), distance: minDistanceBtwStops) else { return nil }
        return line.slice(from: nearestStopToOrigin)
    }

    private func getDestinationRouteLine(destination: CLLocationCoordinate2D, line: LineRoute, minDistanceBtwStops: Double) -> LineRoute? {
        let nearestStopToDestination = line.stops.min(by: {
            $0.toCLLocationCoordinate2D().distance(to: destination) < $1.toCLLocationCoordinate2D().distance(to: destination)
        })

        guard let nearestStopToDestination = nearestStopToDestination, isInDelimitedArea(coordinateA: nearestStopToDestination,
             coordinateB: destination.toCoordinate(), distance: minDistanceBtwStops) else { return nil }
        return line.slice(till: nearestStopToDestination)
    }

    private func getCombinedRouteLines(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D,
                                       candidates: LinesCandidate, minDistanceBtwPoints: Double,
                                       minDistanceBtwStops: Double) -> [AvailableTransport] {
        var availableTransports: [AvailableTransport] = []
        for routeFromOrigin in candidates.originList {
            for routeFromDestination in candidates.destinationList {
                if routeFromOrigin == routeFromDestination { continue }
                for stop in routeFromDestination.stops {
                    let nearestStopToOrigin = routeFromOrigin.stops.min(by: {
                        $0.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D()) <=
                            $1.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D())
                    })
                    let nearestStopToDestination = routeFromDestination.stops.min(by: {
                        $0.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D()) <=
                            $1.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D())
                    })
                    guard let nearestStopToOrigin = nearestStopToOrigin,
                        let nearestStopToDestination = nearestStopToDestination else { continue }
                    if isInDelimitedArea(coordinateA: nearestStopToOrigin, coordinateB: stop, distance: minDistanceBtwStops) {
                        let connectionPoint = getIndexWhere(coordinate: nearestStopToOrigin, coordinateList: routeFromOrigin.stops)
                        // MARK: Origin line splice
                        let newOriginLine = routeFromOrigin.slice(till: nearestStopToOrigin)
                        // MARK: Destination line splice
                        let newDestinationLine = routeFromDestination.slice(from: nearestStopToDestination)
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
