//
//  CountryViewModel.swift
//  RoutesApp_ios
//
//  Created by user on 3/11/22.
//

import Foundation

class CountryViewModel: ViewModel {
    var countryManager: CountryManagerProtocol = CountryFirebaseManager.shared

    var countries = [Country]()
    var filteredCountries = [Country]()

    func getCountries() {
        countryManager.getCountries { result in
            switch result {
            case.success(let countries):
                self.countries = countries
                self.filteredCountries = countries
                self.onFinish?()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func filterCountry(text: String) {
        guard !text.isEmpty else {
            filteredCountries = countries
            self.onFinish?()
            return
        }
        filteredCountries = countries.filter({
            $0.name.lowercased().contains(text.lowercased())
        })
        self.onFinish?()
    }
}
