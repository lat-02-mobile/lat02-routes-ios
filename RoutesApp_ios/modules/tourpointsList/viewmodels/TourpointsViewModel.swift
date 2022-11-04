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
    private var originalTourPointsList = [TourpointEntity]()
    var categories = [TourpointCategoryEntity]()

    var queryAux = ""
    var categoryAux: TourpointCategoryEntity?

    var pointsCount: Int {
        tourpointList.count
    }

    func getTourpoints() {
        localDataManager.getDataFromCoreData(type: TourpointEntity.self, forEntity: TourpointEntity.name) { result in
            switch result {
            case.success(let tourpoints):
                self.tourpointList = tourpoints
                self.originalTourPointsList = tourpoints
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

    func applyFilters(query: String, selectedCat: TourpointCategoryEntity?) {
        filterTourPointsBy(query: query)
        guard let category = selectedCat else {
            onFinish?()
            return
        }
        filterTourPointsBy(category: category)
        onFinish?()
    }

    private func filterTourPointsBy(query: String) {
        if query.isEmpty {
            tourpointList = originalTourPointsList
        } else {
            let normalizedQuery = query.uppercased()
            tourpointList = originalTourPointsList.filter({ $0.name.uppercased().contains(normalizedQuery) })
        }
    }

    private func filterTourPointsBy(category: TourpointCategoryEntity) {
        tourpointList = tourpointList.filter({ $0.category.id == category.id })
    }

    func resetFilteredByCategoryRouteList() {
        filterTourPointsBy(query: queryAux)
        categoryAux = nil
        onFinish?()
    }
}
