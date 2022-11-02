//
//  TourpointsViewModel.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/28/22.
//

import Foundation

class TourpointsViewModel: ViewModel {
    var localDataManager: LocalDataManagerProtocol = LocalDataManager.shared

    var tourpointList = [TourpointEntity]()
    private var categories = [TourpointCategoryEntity]()

    var pointsCount: Int {
        tourpointList.count
    }

    func getTourpoints() {
        localDataManager.getDataFromCoreData(type: TourpointEntity.self, forEntity: TourpointEntity.name) { result in
            switch result {
            case.success(let tourpoints):
                self.tourpointList = tourpoints
                self.getTourpointsCategories()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    private func getTourpointsCategories() {
        localDataManager.getDataFromCoreData(type: TourpointCategoryEntity.self, forEntity: TourpointCategoryEntity.name) { result in
            switch result {
            case.success(let categories):
                self.categories = categories
                self.onFinish?()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func getPointAt(index: Int) -> TourpointEntity {
        tourpointList[index]
    }
}
