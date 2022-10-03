//
//  NSCoordinates.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//

import Foundation

public class NSCoordinates: NSObject, NSCoding {
    var latitude: Double
    var longitude: Double

    enum Key: String {
        case latitude
        case longitude
    }

    init(lat: Double, lon: Double) {
        self.latitude = lat
        self.longitude = lon
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: Key.latitude.rawValue)
        aCoder.encode(longitude, forKey: Key.longitude.rawValue)
    }

    public required convenience init?(coder: NSCoder) {
        let lat = coder.decodeDouble(forKey: Key.latitude.rawValue)
        let lon = coder.decodeDouble(forKey: Key.longitude.rawValue)
        self.init(lat: lat, lon: lon)
    }
}
