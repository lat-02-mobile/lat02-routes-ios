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
    var cities = [CityRoute]()

    func getCities(text: String, completion: @escaping ((_ cities: [CityRoute]) -> Void)) {
        cityManager.getCitiesByName(parameter: text) { result in
            switch result {
            case.success(let cities):
                completion(cities)
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func getCountry(id: String, completion: @escaping ((_ cities: [Country]) -> Void)) {
        cityManager.getCountryById(id: id) { result in
            switch result {
            case.success(let countries):
                completion(countries)
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
