//
//  CLLocationCoordinate2DExtension.swift
//  RoutesApp_ios
//
//  Created by user on 29/8/22.
//

import CoreLocation

extension CLLocationCoordinate2D {
    /// Returns the distance between two coordinates in meters.
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        return CLLocation(latitude: latitude, longitude: longitude)
            .distance(from: CLLocation(latitude: to.latitude, longitude: to.longitude))
    }

    func toCoordinate() -> Coordinate {
        return Coordinate(latitude: latitude, longitude: longitude)
    }
}
