//
//  RouteListManager.swift
//  RoutesApp_ios
//
//  Created by user on 22/9/22.
//

import Foundation
import FirebaseFirestore

protocol LineRouteManagerProtocol {
    func getLineRoute(idLine: String, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void)
    func getLineRouteByDateGreaterThanOrEqualTo(idLine: String, date: Date, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void)
    func getLineRoutesByLine(idLine: String, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void)
    func getLineRoutesByLineAsync(idLine: String) async throws -> [LineRouteInfo]
    func updateLineRoute(lineRouteInfo: LineRouteInfo, completion: @escaping(Result<LineRouteInfo, Error>) -> Void)
    func createNewLineRoute(idLine: String, lineRouteName: String, avgVel: String, color: String, start: GeoPoint,
                            end: GeoPoint, routePoints: [GeoPoint], stops: [GeoPoint], completion: @escaping(Result<LineRouteInfo, Error>) -> Void)
    func updateLineRoute(lineRoute: LineRouteInfo, newLineRouteName: String, newAvgVel: String, newColor: String,
                         newRoutePoints: [GeoPoint], newStops: [GeoPoint], newStart: GeoPoint, newEnd: GeoPoint,
                         completion: @escaping(Result<Bool, Error>) -> Void)
    func deleteLineRoute(idLineRoute: String, completion: @escaping(Result<Bool, Error>) -> Void)
}

class LineRouteFirebaseManager: LineRouteManagerProtocol {
    static let shared = LineRouteFirebaseManager()
    let firebaseManager = FirebaseFirestoreManager.shared

    func getLineRoute(idLine: String, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void) {
        firebaseManager.getDocumentsByParameterContains(type: LineRouteInfo.self, forCollection: .LineRoute, field: "idLine",
                                                        parameter: idLine) { result in
            switch result {
            case .success(let lines):
                completion(.success(lines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getLineRouteByDateGreaterThanOrEqualTo(idLine: String, date: Date, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void) {
        firebaseManager.getDocumentsByParameterContainsDateGreaterThanOrEqualTo(type: LineRouteInfo.self, forCollection: .LineRoute, field: "idLine",
                                                            fieldDate: "updateAt", date: date, parameter: idLine) { result in
            switch result {
            case .success(let lines):
                completion(.success(lines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getLineRoutesByLine(idLine: String, completion: @escaping(Result<[LineRouteInfo], Error>) -> Void) {
        firebaseManager.getDocumentsByParameterContains(type: LineRouteInfo.self,
                                                        forCollection: .LineRoute,
                                                        field: "idLine",
                                                        parameter: idLine,
                                                        completion: completion)
    }

    func getLineRoutesByLineAsync(idLine: String) async throws -> [LineRouteInfo] {
        do {
            let lineRoutes = try await firebaseManager.getDocumentsByParameterContainsAsync(
                type: LineRouteInfo.self,
                forCollection: .LineRoute,
                field: "idLine",
                parameter: idLine)
            return lineRoutes
        } catch let error {
            throw error
        }
    }

    func updateLineRoute(lineRouteInfo: LineRouteInfo, completion: @escaping(Result<LineRouteInfo, Error>) -> Void) {
        firebaseManager.updateDocument(document: lineRouteInfo, collection: .LineRoute) { result in
            switch result {
            case .success(let lineRouteInfo):
                completion(.success(lineRouteInfo))
            case .failure(let error):
            completion(.failure(error))
            }
        }
    }

    func createNewLineRoute(idLine: String,
                            lineRouteName: String,
                            avgVel: String,
                            color: String,
                            start: GeoPoint,
                            end: GeoPoint,
                            routePoints: [GeoPoint],
                            stops: [GeoPoint],
                            completion: @escaping(Result<LineRouteInfo, Error>) -> Void) {
        let newLineRouteId = firebaseManager.getDocID(forCollection: .LineRoute)
        guard !idLine.isEmpty else {return}
        let newLineRoute = LineRouteInfo(name: lineRouteName,
                                         id: newLineRouteId,
                                         idLine: idLine,
                                         line: firebaseManager.getDocReference(forCollection: .Lines, documentID: idLine),
                                         routePoints: routePoints,
                                         start: start,
                                         stops: stops,
                                         end: end,
                                         averageVelocity: avgVel,
                                         color: color,
                                         updateAt: Timestamp(),
                                         createAt: Timestamp())
        firebaseManager.addDocument(document: newLineRoute, collection: .LineRoute) { result in
            switch result {
            case .success(let lineRoute):
                completion(.success(lineRoute))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateLineRoute(lineRoute: LineRouteInfo,
                         newLineRouteName: String,
                         newAvgVel: String,
                         newColor: String,
                         newRoutePoints: [GeoPoint],
                         newStops: [GeoPoint],
                         newStart: GeoPoint,
                         newEnd: GeoPoint,
                         completion: @escaping(Result<Bool, Error>) -> Void) {
        let newLineRoute = LineRouteInfo(name: newLineRouteName,
                                         id: lineRoute.id,
                                         idLine: lineRoute.idLine,
                                         line: lineRoute.line,
                                         routePoints: newRoutePoints,
                                         start: newStart,
                                         stops: newStops,
                                         end: newEnd,
                                         averageVelocity: newAvgVel,
                                         color: newColor,
                                         updateAt: Timestamp(),
                                         createAt: lineRoute.createAt)
        firebaseManager.updateDocument(document: newLineRoute, forCollection: .LineRoute) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteLineRoute(idLineRoute: String, completion: @escaping(Result<Bool, Error>) -> Void) {
        firebaseManager.deleteDocument(type: LineRouteInfo.self, forCollection: .LineRoute, documentID: idLineRoute) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
