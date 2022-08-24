//
//  CityRoute.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import Foundation

struct CityRoute: Codable, Equatable, BaseModel {
    var id: String
    var name: String
    var countryId: String
    var lat: String
    var lng: String
}
