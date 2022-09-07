//
//  SearchLocationViewModel.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/6/22.
//

import Foundation
import GooglePlaces

class SearchLocationViewModel: ViewModel {
    let googleMapsManager = GoogleMapsManager.shared
    private var placesList = [Place]()
    var placesCount: Int {
        placesList.count
    }

    func fetchPlaces(query: String, placeBias: GMSPlaceLocationBias) {
        googleMapsManager.findPlaces(query: query, placeBias: placeBias) { result in
            switch result {
            case.success(let places):
                self.placesList = places
                self.onFinish?()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func getPlaceAt(index: Int) -> Place {
        placesList[index]
    }
}
