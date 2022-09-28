//
//  ClPlaceMark.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 26/9/22.
//

import Foundation
import GoogleMaps

extension CLPlacemark {
    var singleStreetAddress: String? {
        if let name = name {
            return name
        }
        return nil
    }
    var compactAddress: String? {
        if let name = name {
            var result = name
            if let street = thoroughfare {
                result += ", \(street)"
            }
            if let city = locality {
                result += ", \(city)"
            }
            if let country = country {
                result += ", \(country)"
            }
            return result
        }
        return nil
    }
}
