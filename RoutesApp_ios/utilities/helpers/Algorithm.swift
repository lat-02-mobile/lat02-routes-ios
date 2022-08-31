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
                             cityRoute: CityRoute, minDistanceBtwPoints: Double, minDistanceBtwStops: Double) -> [AvailableTransport] {
        var availableTransports = [AvailableTransport]()
        var originCandidates = [TransportationWithLines]()
        var destinationCandidates = [TransportationWithLines]()
        for transport in cityRoute.transportationMethods {
            // MARK: Add one line routes
            let oneRouteLines = getOneRouteLines(origin: origin, destination: destination,
                 transport: transport, minDistanceBtwStops: minDistanceBtwStops)
            availableTransports.insert(contentsOf: oneRouteLines, at: 0)
            // MARK: Add route candidates
            originCandidates.insert(contentsOf: getOriginRoutes(origin: origin, transport: transport,
                   minDistanceBtwStops: minDistanceBtwStops), at: 0)
            destinationCandidates.insert(contentsOf: getDestinationRoutes(destination: destination,
                   transport: transport, minDistanceBtwStops: minDistanceBtwStops), at: 0)
        }
        let candidates = LinesCandidate(originList: originCandidates, destinationList: destinationCandidates)
        // MARK: Add the combined routes
        let combinedAvailableTransports = getCombinedRoutes(origin: origin, destination: destination,
            candidates: candidates, minDistanceBtwPoints: minDistanceBtwPoints,
            minDistanceBtwStops: minDistanceBtwStops)
        availableTransports.insert(contentsOf: combinedAvailableTransports, at: 0)

        return availableTransports
    }

    private func getOneRouteLines(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D,
                                  transport: TrasportationMethod, minDistanceBtwStops: Double) -> [AvailableTransport] {
        var availableTransports = [AvailableTransport]()
        for line in transport.lines {
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
                let newLine = Array(line.routePoints[indexOriginPoint...indexDestinationPoint])

                let route = Route(name: line.name, routePoints: newLine, start: line.start, stops: newStops)
                availableTransports.append(AvailableTransport(connectionPoint: nil,
                      transports: [TransportationWithLines(name: transport.name, line: route)]))
            }
        }
        return availableTransports
    }

    private func getOriginRoutes(origin: CLLocationCoordinate2D, transport: TrasportationMethod, minDistanceBtwStops: Double) -> [TransportationWithLines] {
        var originRoutes = [TransportationWithLines]()
        for line in transport.lines {
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
                let newLine = Array(line.routePoints[indexOriginPoint...])

                let route = Route(name: line.name, routePoints: newLine, start: line.start, stops: newStops)
                originRoutes.append(TransportationWithLines(name: transport.name, line: route))
            }
        }
        return originRoutes
    }

    private func getDestinationRoutes(destination: CLLocationCoordinate2D, transport: TrasportationMethod, minDistanceBtwStops: Double) -> [TransportationWithLines] {
        var destinationRoutes = [TransportationWithLines]()
        for line in transport.lines {
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
                let newLine = Array(line.routePoints[...indexDestinationPoint])

                let route = Route(name: line.name, routePoints: newLine, start: line.start, stops: newStops)
                destinationRoutes.append(TransportationWithLines(name: transport.name, line: route))
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
                for stop in routeFromDestination.line.stops {
                    let nearestStopToOrigin = routeFromOrigin.line.stops.min(by: {
                        $0.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D()) <=
                            $1.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D())
                    })
                    guard let nearestStopToOrigin = nearestStopToOrigin else { continue }
                    let indexOfNearestStopToOrigin = getIndexWhere(coordinate: nearestStopToOrigin, coordinateList: routeFromOrigin.line.stops)
                    if nearestStopToOrigin.toCLLocationCoordinate2D().distance(to: stop.toCLLocationCoordinate2D()) <= minDistanceBtwStops {
                        // MARK: Origin line splice
                        let indexOfOriginRoute = getIndexWhere(coordinate: nearestStopToOrigin, coordinateList: routeFromOrigin.line.routePoints)
                        let lineOriginRoute = Array(routeFromOrigin.line.routePoints[0...indexOfOriginRoute])
                        let originStops = Array(routeFromOrigin.line.stops[0...indexOfNearestStopToOrigin])
                        let originTransportation = TransportationWithLines(name: routeFromOrigin.name,
                           line: Route(name: routeFromOrigin.line.name, routePoints: lineOriginRoute,
                           start: routeFromOrigin.line.start, stops: originStops))
                        // MARK: Destination line splice
                        let indexOfDestinationRoute = getIndexWhere(coordinate: stop, coordinateList: routeFromDestination.line.routePoints)
                        let indexOfDestinationStop = getIndexWhere(coordinate: stop, coordinateList: routeFromDestination.line.stops)
                        let lineDestinationRoute = Array(routeFromDestination.line.routePoints[indexOfDestinationRoute...])
                        let destinationStops = Array(routeFromDestination.line.stops[indexOfDestinationStop...])
                        let destinationTransportation = TransportationWithLines(name: routeFromDestination.name,
                            line: Route(name: routeFromDestination.line.name, routePoints: lineDestinationRoute,
                            start: routeFromDestination.line.start, stops: destinationStops))
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
