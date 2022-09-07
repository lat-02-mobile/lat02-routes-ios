//
//  GoogleMapsManager.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/5/22.
//

import Foundation
import GooglePlaces

enum PlacesError: Error {
    case failedToRetrieve
}

protocol GoogleMapsManagerProtocol {
    func findPlaces(query: String, placeBias: GMSPlaceLocationBias, completion: @escaping(Result<[Place], Error>) -> Void)
}

class GoogleMapsManager: GoogleMapsManagerProtocol {
    static let shared = GoogleMapsManager()

    private let client = GMSPlacesClient.shared()

    func findPlaces(query: String, placeBias: GMSPlaceLocationBias, completion: @escaping(Result<[Place], Error>) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.locationBias = placeBias

        client.findAutocompletePredictions(
            fromQuery: query,
            filter: filter,

            sessionToken: nil) { results, error in
            guard let results = results, error == nil else {
                completion(.failure(PlacesError.failedToRetrieve))
                return
            }
            let places: [Place] = results.compactMap({
                Place(name: $0.attributedFullText.string, identifier: $0.placeID)
            })
            completion(.success(places))
        }
    }
}
