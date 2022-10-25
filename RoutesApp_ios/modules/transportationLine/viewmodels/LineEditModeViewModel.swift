//
//  LineEditModeViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 24/10/22.
//

import Foundation

class LineEditModeViewModel: ViewModel {

    var localDataManager: LocalDataManagerProtocol = LocalDataManager.shared
    var cityManager: CityManagerProtocol = CityFirebaseManager.shared
    var lineManager: LineManagerProtocol = LineFirebaseManager.shared
    var categories = [LineCategoryEntity]()
    var cities = [Cities]()

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

    func getCities() {
        cityManager.getCities { result in
            switch result {
            case.success(let cities):
                self.cities = cities
                self.onFinish?()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func createNewLine() {
        lineManager.createNewLine(newLineName: "", idCategory: "", idCity: "")
    }

    func editLine() {
    }

    func deleteLine() {
    }
}
