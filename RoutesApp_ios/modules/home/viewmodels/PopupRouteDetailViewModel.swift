//
//  RouteDetailViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 19/9/22.
//

import Foundation
import GoogleMaps

class PopupRouteDetailViewModel {
    let favoritesManager = FavoriteDestinationsManager.shared
    func saveDestination(latitude: Double, longitude: Double, name: String) {
        favoritesManager.createNewFavoriteDestination(latitude: String(latitude), longitude: String(longitude), name: name)
    }
    func getAllFavorites() -> [FavoriteDest] {
        let result = favoritesManager.getAllFavoriteDestination()
        return result
    }
    func getNearestFavDest(lat: Double, lng: Double) -> FavoriteDest? {
        let selectedDestination = CLLocation(latitude: lat, longitude: lng)
        let foundFav = getAllFavorites().first(where: { favDest in
            let favDestCoords = CLLocation(latitude: Double(favDest.latitude!)!, longitude: Double(favDest.longitude!)!)
            let distanceInMeters = selectedDestination.distance(from: favDestCoords)
            return distanceInMeters < 8.0
        })
        return foundFav
    }
    func removeFavorite(favId: Int64) -> Bool {
        return favoritesManager.deleteFavoriteDestination(idFav: favId)
    }
}
