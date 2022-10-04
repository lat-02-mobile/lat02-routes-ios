//
//  GeoPointExtension.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 9/28/22.
//

import Foundation
import Firebase

extension GeoPoint {
    func toCoordinate() -> Coordinate {
        Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
}
