//
//  FavoriteDestinationsManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 19/9/22.
//

import Foundation

class FavoriteDestinationsManager {
    let coreDataManager = CoreDataManager.shared
    static let shared = FavoriteDestinationsManager()
    func getAllFavoriteDestination() -> [FavoriteDest] {
        let currentCityId = ConstantVariables.defaults.string(forKey: ConstantVariables.defCityId)
        let currentLoggedUserId = ConstantVariables.defaults.string(forKey: ConstantVariables.defUserLoggedId)
        let data: [FavoriteDest] = coreDataManager.getData(entity: "FavoriteDest")
        let userFavorites = data.filter { fav in
            fav.idCity == currentCityId && fav.idUser == currentLoggedUserId
        }
        return userFavorites
    }
    func createNewFavoriteDestination(latitude: String, longitude: String, name: String) {
        let newFavDest = FavoriteDest(context: coreDataManager.getContext())
        let userId = ConstantVariables.defaults.string(forKey: ConstantVariables.defUserLoggedId)
        let currentCityId = ConstantVariables.defaults.string(forKey: ConstantVariables.defCityId)
        newFavDest.id = Int64.random(in: 0...100000)
        newFavDest.name = name
        newFavDest.latitude = latitude
        newFavDest.longitude = longitude
        newFavDest.createdAt = Date()
        newFavDest.idUser = userId
        newFavDest.idCity = currentCityId
        coreDataManager.saveContext()
    }
    func deleteFavoriteDestination(idFav: Any) -> Bool {
        let result = coreDataManager.deleteEntityObjectByKeyValue(entityName: FavoriteDest.self, key: "id", value: idFav)
        if result {
            print("Object deleted")
            return true
        }
        return false
    }
}
