//
//  SettingsPopupViewModel.swift
//  RoutesApp_ios
//
//  Created by admin on 10/21/22.
//

import Foundation
import CoreLocation
import GoogleMaps
import GooglePlaces

class SettingsPopupViewModel {

    private var tourpointList = [TourpointEntity]()
    private var categories = [TourpointCategoryEntity]()
    let tourpointsViewModel = TourpointsViewModel()

    func getTourpointsMarkers(tourpoint: TourpointEntity) -> CLLocationCoordinate2D {
        let forTourpointMarker = tourpoint.destination.toCLLocationCoordinate2D()
        return forTourpointMarker
    }
}
