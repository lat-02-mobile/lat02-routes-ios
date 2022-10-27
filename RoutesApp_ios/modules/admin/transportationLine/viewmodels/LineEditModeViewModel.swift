//
//  LineEditModeViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 24/10/22.
//

import Foundation

class LineEditModeViewModel: ViewModel {

    var lineCategoryManager: LineCategoryManagerProtocol = LineCategoryFirebaseManager()
    var cityManager: CityManagerProtocol = CityFirebaseManager.shared
    var lineManager: LineManagerProtocol = LineFirebaseManager.shared

    var categories = [LinesCategory]()
    var cities = [Cities]()
    var onFinishCategories: (() -> Void)?
    var onFinishCities: (() -> Void)?

    func getCategories() {
        lineCategoryManager.getCategories { result in
            switch result {
            case .success(let categories):
                self.categories = categories
                self.onFinishCategories?()
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
                self.onFinishCities?()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func createNewLine(newLineName: String, idCategory: String, idCity: String) {
        guard !newLineName.isEmpty else {
            self.onError?(String.localizeString(localizedString: StringResources.adminLinesMustProvideName))
            return
        }
        lineManager.createNewLine(newLineName: newLineName, idCategory: idCategory, idCity: idCity) { result in
            switch result {
            case .success:
                self.onFinish?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func editLine(targetLine: Lines, newLineName: String, newIdCategory: String, newIdCity: String, newEnable: Bool) {
        guard !newLineName.isEmpty else {
            self.onError?(String.localizeString(localizedString: StringResources.adminLinesMustProvideName))
            return
        }
        lineManager.updateLine(line: targetLine, newLineName: newLineName,
                               newIdCategory: newIdCategory, newIdCity: newIdCity,
                               newEnable: newEnable) { result in
            switch result {
            case .success(let status):
                if status {
                    self.onFinish?()
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func deleteLine(idLine: String) {
        lineManager.deleteLine(idLine: idLine) { result in
            switch result {
            case .success(let status):
                if status {
                    self.onFinish?()
                } else {
                    self.onError?(String.localizeString(localizedString: StringResources.adminLinesLineHasRouteDeleteFirst))
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
