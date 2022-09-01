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
               nearestStopToDestination.toCLLocationCoordinate2D().distance(to: destination) <= minDistanceBtwStops,
               nearestStopToOrigin.toCLLocationCoordinate2D().distance(to: origin) <= minDistanceBtwStops {
                // MARK: Slice Stops
                let indexStopOrigin = getIndexWhere(coordinate: nearestStopToOrigin, coordinateList: line.stops)
                let indexStopDestination = getIndexWhere(coordinate: nearestStopToDestination, coordinateList: line.stops)

                let newStops = Array(line.stops[indexStopOrigin...indexStopDestination])

                // MARK: Slice Route points
                let indexOriginPoint = getIndexWhere(coordinate: nearestStopToOrigin, coordinateList: line.routePoints)
                let indexDestinationPoint = getIndexWhere(coordinate: nearestStopToDestination, coordinateList: line.routePoints)

                // MARK: New SubLine
                let newRoutePoints = Array(line.routePoints[indexOriginPoint...indexDestinationPoint])

                let newLine = Line(name: line.name, categoryRef: line.categoryRef, routePoints: newRoutePoints, start: line.start, stops: newStops)
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
               nearestStopToOrigin.toCLLocationCoordinate2D().distance(to: origin) <= minDistanceBtwStops {
                // MARK: Slice Stops
                let indexStopOrigin = getIndexWhere(coordinate: nearestStopToOrigin, coordinateList: line.stops)
                let newStops = Array(line.stops[indexStopOrigin...])

                // MARK: Slice Route points
                let indexOriginPoint = getIndexWhere(coordinate: nearestStopToOrigin, coordinateList: line.routePoints)
                let newRoutePoints = Array(line.routePoints[indexOriginPoint...])

                let newLine = Line(name: line.name, categoryRef: line.categoryRef, routePoints: newRoutePoints, start: line.start, stops: newStops)
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
               nearestStopToDestination.toCLLocationCoordinate2D().distance(to: destination) <= minDistanceBtwStops {
                // MARK: Slice Stops
                let indexStopDestination = getIndexWhere(coordinate: nearestStopToDestination, coordinateList: line.stops)
                let newStops = Array(line.stops[0...indexStopDestination])

                // MARK: Slice Route points
                let indexDestinationPoint = getIndexWhere(coordinate: nearestStopToDestination, coordinateList: line.routePoints)
                let newRoutePoints = Array(line.routePoints[...indexDestinationPoint])

                let newLine = Line(name: line.name, categoryRef: line.categoryRef, routePoints: newRoutePoints, start: line.start, stops: newStops)
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
                if routeFromOrigin == routeFromDestination {
                    continue
                }
                for stop in routeFromDestination.stops {
                    let nearestStopToOrigin = routeFromOrigin.stops.min(by: {
                        $0.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D()) <=
                            $1.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D())
                    })
                    guard let nearestStopToOrigin = nearestStopToOrigin else { continue }
                    let indexOfNearestStopToOrigin = getIndexWhere(coordinate: nearestStopToOrigin, coordinateList: routeFromOrigin.stops)
                    if nearestStopToOrigin.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D()) <= minDistanceBtwStops {
                        // MARK: Origin line splice
                        let indexOfOriginRoute = getIndexWhere(coordinate: nearestStopToOrigin, coordinateList: routeFromOrigin.routePoints)
                        let lineOriginRoute = Array(routeFromOrigin.routePoints[0...indexOfOriginRoute])
                        let originStops = Array(routeFromOrigin.stops[0...indexOfNearestStopToOrigin])
                        let originTransportation = Line(name: routeFromOrigin.name,
                            categoryRef: routeFromOrigin.categoryRef, routePoints: lineOriginRoute,
                            start: routeFromOrigin.start, stops: originStops)
                        // MARK: Destination line splice
                        let indexOfDestinationRoute = getIndexWhere(coordinate: stop, coordinateList: routeFromDestination.routePoints)
                        let indexOfDestinationStop = getIndexWhere(coordinate: stop, coordinateList: routeFromDestination.stops)
                        let lineDestinationRoute = Array(routeFromDestination.routePoints[indexOfDestinationRoute...])
                        let destinationStops = Array(routeFromDestination.stops[indexOfDestinationStop...])
                        let destinationTransportation = Line(name: routeFromDestination.name,
                             categoryRef: routeFromDestination.categoryRef, routePoints: lineDestinationRoute,
                             start: routeFromDestination.start, stops: destinationStops)
                        // MARK: Add the combined transportation
                        availableTransports.append(AvailableTransport(connectionPoint: indexOfNearestStopToOrigin,
                              transports: [originTransportation, destinationTransportation]))
                    }
                }
            }
        }
        return availableTransports
    }

    private func getIndexWhere(coordinate: Coordinate, coordinateList: [Coordinate]) -> Int {
        return coordinateList.firstIndex(where: { $0 == coordinate }) ?? -1
    }
}
