//
//  HomeVIewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 10/8/22.
//

import Foundation
import CoreLocation
import GoogleMaps

enum PointsSelectionStatus {
case pendingOrigin, pendingDestination, bothSelected
}

class HomeViewModel {
    var currentPosition: CLLocationCoordinate2D?
    var origin: GMSMarker?
    var destination: GMSMarker?
    var pointsSelectionStatus = PointsSelectionStatus.pendingOrigin
}
