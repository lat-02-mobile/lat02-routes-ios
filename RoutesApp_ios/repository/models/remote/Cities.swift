//
//  CityRoute.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import Foundation

struct Cities: Codable, Equatable, BaseModel {
    var country: String
    var id: String
    var idCountry: String
    var lat: String
    var lng: String
    var name: String
}
