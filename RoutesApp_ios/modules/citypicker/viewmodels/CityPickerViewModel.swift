//
//  CityPickerViewModel.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import Foundation

class CityPickerViewModel {

    var cityManager: CityManagerProtocol = CityFirebaseManager.shared
    var onFinish: (() -> Void)?
    var onError: ((_ error: String) -> Void)?
    var cities = [Cities]()
    var citiesOriginalList = [Cities]()

    func getCities() {
        cityManager.getCities { result in
            switch result {
            case.success(let cities):
                self.cities = cities
                self.citiesOriginalList = cities
                self.onFinish?()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func getCitiesByName(text: String) {
        cityManager.getCitiesByName(parameter: text) { result in
            switch result {
            case.success(let cities):
                self.cities = cities
                self.onFinish?()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func getCountry(id: String, completion: @escaping ((_ cities: Country) -> Void)) {
        cityManager.getCountryById(id: id) { result in
            switch result {
            case.success(let country):
                completion(country)
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func filterCity(text: String) {
        cities = cities.filter({
            $0.name.contains(text)
        })
    }
}
