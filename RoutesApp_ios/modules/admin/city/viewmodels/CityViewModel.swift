//
//  CityViewModel.swift
//  RoutesApp_ios
//
//  Created by user on 3/11/22.
//

import Foundation

class CityViewModel: ViewModel {
    var cityManager: CityManagerProtocol = CityFirebaseManager.shared

    var cities = [Cities]()
    var filteredCities = [Cities]()
    var countryId = ""

    func getCities() {
        cityManager.getCityByCountryId(id: countryId) { result in
            switch result {
            case.success(let cities):
                self.cities = cities
                self.filteredCities = cities
                self.onFinish?()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func createCity(name: String, latitude: String, longitude: String, country: String, idCountry: String,
                    completion: @escaping(Result<Cities, Error>) -> Void) {
        let newCity = Cities(country: country, id: "", idCountry: idCountry, lat: latitude, lng: longitude, name: name)
        cityManager.createCity(city: newCity, completion: completion)
    }

    func updateCity(id: String, name: String, latitude: String, longitude: String, country: String, idCountry: String,
                    completion: @escaping(Result<Bool, Error>) -> Void) {
        let city = Cities(country: country, id: id, idCountry: idCountry, lat: latitude, lng: longitude, name: name)
        cityManager.updateCity(city: city, completion: completion)
    }

    func removeCity(city: Cities, completion: @escaping(Result<Bool, Error>) -> Void) {
        cityManager.deleteCity(cityId: city.id, completion: completion)
    }

    func filterCities(text: String) {
        guard !text.isEmpty else {
            filteredCities = cities
            self.onFinish?()
            return
        }
        filteredCities = cities.filter({
            $0.name.lowercased().contains(text.lowercased())
        })
        self.onFinish?()
    }
}
