//
//  RouteListViewModel.swift
//  RoutesApp_ios
//
//  Created by admin on 8/23/22.
//

import Foundation

class RouteListViewModel: ViewModel {
    var localDataManager: LocalDataManagerProtocol = LocalDataManager.shared

    var lines = [LineEntity]()
    private var originalLines = [LineEntity]()
    var categories = [LineCategoryEntity]()

    var queryAux = ""
    var categoryAux: LineCategoryEntity?

    func getLines() {
        localDataManager.getDataFromCoreData(type: LineEntity.self, forEntity: LineEntity.name) { result in
            switch result {
            case .success(let lines):
                self.originalLines = lines
                self.lines = lines
                self.getCategories()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func getCategories() {
        localDataManager.getDataFromCoreData(type: LineCategoryEntity.self, forEntity: LineCategoryEntity.name) { result in
            switch result {
            case .success(let categories):
                self.categories = categories
                self.onFinish?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func applyFilters(query: String, selectedCat: LineCategoryEntity?) {
        filterLinesBy(query: query)
        guard let category = selectedCat else {
            onFinish?()
            return
        }
        filterLinesBy(category: category)
        onFinish?()
    }

    private func filterLinesBy(query: String) {
        if query.isEmpty {
            lines = originalLines
        } else {
            let normalizedQuery = query.uppercased()
            lines = originalLines.filter({ $0.name.uppercased().contains(normalizedQuery) })
        }
    }

    private func filterLinesBy(category: LineCategoryEntity) {
        lines = lines.filter({ $0.idCategory == category.id })
    }

    func resetFilteredByCategoryRouteList() {
        filterLinesBy(query: queryAux)
        categoryAux = nil
        onFinish?()
    }

}
