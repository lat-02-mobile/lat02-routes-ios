//
//  FavoritesListViewModel.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/10/22.
//

import UIKit

class FavoritesListViewModel: ViewModel {
    var favoritesManager = FavoriteDestinationsManager.shared

    private var favoritesList = [FavoriteDest]()

    var pointsCount: Int {
        favoritesList.count
    }

    func getFavorites() {
        favoritesList = favoritesManager.getAllFavoriteDestination()
        onFinish?()
    }

    func getFavoriteAt(index: Int) -> FavoriteDest {
        favoritesList[index]
    }

    func removeFavorite(favId: Int64) {
        if favoritesManager.deleteFavoriteDestination(idFav: favId) {
            getFavorites()
        } else {
            onError?(String.localizeString(localizedString: ConstantVariables.errorUpdatingData))
        }
    }

    func updateFavorite(favorite: FavoriteDest, newName: String) {
        favoritesManager.updateFavoriteDestinationName(destination: favorite, newName: newName) { result in
            switch result {
            case.success:
                self.getFavorites()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
