//
//  CityFirebaseManager.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import Foundation

protocol CityManagerProtocol {
    func getCitiesByName(parameter: String, completion: @escaping(Result<[Cities], Error>) -> Void)
    func getCountryById(id: String, completion: @escaping(Result<Country, Error>) -> Void)
    func getCities(completion: @escaping(Result<[Cities], Error>) -> Void)
    func getCityById(id: String, completion: @escaping(Result<Cities, Error>) -> Void)
    func getCityByCountryId(id: String, completion: @escaping (Result<[Cities], Error>) -> Void)
    func createCity(city: Cities, completion: @escaping(Result<Cities, Error>) -> Void)
    func updateCity(city: Cities, completion: @escaping(Result<Bool, Error>) -> Void)
    func deleteCity(cityId: String, completion: @escaping(Result<Bool, Error>) -> Void)
}

class CityFirebaseManager: CityManagerProtocol {
    let firebaseManager = FirebaseFirestoreManager.shared
    static let shared = CityFirebaseManager()

    func getCityById(id: String, completion: @escaping (Result<Cities, Error>) -> Void) {
        self.firebaseManager.getSingleDocumentById(type: Cities.self, forCollection: .Cities, documentID: id, completion: completion)
    }

    func getCities(completion: @escaping (Result<[Cities], Error>) -> Void) {
        self.firebaseManager.getDocumentsWithLimit(type: Cities.self, forCollection: .Cities, limit: 10, completion: completion)
    }

    func getCitiesByName(parameter: String, completion: @escaping (Result<[Cities], Error>) -> Void) {
        self.firebaseManager.getDocumentsByParameterContains(type: Cities.self, forCollection: .Cities,
                                                             field: "name", parameter: parameter, completion: completion)
    }

    func getCountryById(id: String, completion: @escaping (Result<Country, Error>) -> Void) {
        self.firebaseManager.getSingleDocumentById(type: Country.self, forCollection: .Countries,
                                            documentID: id, completion: completion)
    }

    func getDocumentsFromCity<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, usingReference: Bool = false,
                                            completion: @escaping (Result<[T], Error>) -> Void) {
        guard let currentCity = ConstantVariables.defaults.string(forKey: ConstantVariables.defCityId) else { return }
        var cityRef: Any // it's any bacause it can be a string or a documentReference
        if usingReference {
            cityRef = firebaseManager.getDocReference(forCollection: .Cities, documentID: currentCity)
        } else {
            cityRef = currentCity
        }
        firebaseManager.getDocumentsByParameterContains(type: type, forCollection: collection,
                                                        field: "idCity", parameter: cityRef, completion: completion)
    }
    func getDocumentsFromCityByDateGreaterThanOrEqualTo<T: Decodable>(type: T.Type,
                                                                      forCollection collection: FirebaseCollections,
                                                                      date: Date,
                                                                      usingReference: Bool = false,
                                                                      completion: @escaping (Result<[T], Error>) -> Void) {
        guard let currentCity = ConstantVariables.defaults.string(forKey: ConstantVariables.defCityId) else { return }
        var cityRef: Any // it's any bacause it can be a string or a documentReference
        if usingReference {
            cityRef = firebaseManager.getDocReference(forCollection: .Cities, documentID: currentCity)
        } else {
            cityRef = currentCity
        }
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let dateCalender = Calendar.current.date(from: components) ?? Date()
        firebaseManager.getDocumentsByParameterContainsDateGreaterThanOrEqualTo(type: type,
                                                                                forCollection: collection,
                                                                                field: "idCity",
                                                                                fieldDate: "updateAt",
                                                                                date: dateCalender,
                                                                                parameter: cityRef,
                                                                                completion: completion)
    }

    func getCityByCountryId(id: String, completion: @escaping (Result<[Cities], Error>) -> Void) {
        self.firebaseManager.getDocumentsByParameterContains(type: Cities.self, forCollection: .Cities,
                                                             field: "idCountry", parameter: id, completion: completion)
    }

    func createCity(city: Cities, completion: @escaping(Result<Cities, Error>) -> Void) {
        let newCityId = firebaseManager.getDocID(forCollection: .Cities)
        guard !city.idCountry.isEmpty else {return}
        let newCity = Cities(country: city.country, id: newCityId, idCountry: city.idCountry, lat: city.lat,
                             lng: city.lng, name: city.name)
        firebaseManager.addDocument(document: newCity, collection: .Cities) { result in
            switch result {
            case .success(let status):
                completion(.success(status))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateCity(city: Cities, completion: @escaping(Result<Bool, Error>) -> Void) {
        guard !city.idCountry.isEmpty else {return}
        let newCity = Cities(country: city.country, id: city.id, idCountry: city.idCountry, lat: city.lat,
                             lng: city.lng, name: city.name)
        firebaseManager.updateDocument(document: newCity, forCollection: .Cities) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteCity(cityId: String, completion: @escaping(Result<Bool, Error>) -> Void) {
        firebaseManager.deleteDocument(type: Cities.self, forCollection: .Cities, documentID: cityId) { delResult in
            switch delResult {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
