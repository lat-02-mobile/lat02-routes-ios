//
//  ConstantVariables.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 9/8/22.
//

import Foundation

class ConstantVariables {
    static let databaseName = "RoutesApp_ios"
    static let cityCellNib = "CityTableViewCell"
    static let cityCellIdentifier = "CityCell"
    static let defaults = UserDefaults.standard
    static let deflaunchApp = "LaunchFirstTime"
    static let defCitySelected = "CitySelected"
    static let defCityLat = "CityLatitude"
    static let defCityLong = "CityLongitude"
    static let primaryColor = "primary-color"
    static let routeListCell = "RouteListTableViewCell"
    static let routeTitle = "routeTitle"
    static let filterIcon = "filter-icon"

    // PlaceTableViewCell
    static let placeCellNib = "PlaceTableViewCell"
    static let placeCellIdentifier = "PlaceCell"

    // image names
    static let destinationPoint = "destination_point"
    static let originPoint = "origin_point"

    // localized strings
    static let origin = "origin"
    static let selectOrigin = "select-origin"
    static let selectDestination = "select-destination"
    static let destination = "destination"
    static let done = "done"

    static let localizationPermissionAlertTitle = "localization-permission-alert-title"
    static let localizationPermissionAlertMessage = "localization-permission-alert-message"
    static let localizationPermissionAlertSettings = "localization-permission-alert-settings"
    static let localizationPermissionAlertCancel = "localization-permission-alert-cancel"

    // Google Maps helper
    static let polylinePadding = 80
    static let originMarkerName = "origin_point"
    static let destinationMarkerName = "destination_point"
    static let stopMarkerName = "route-stop"
    static let localizationLinesFilterTitle = "filter-title"

    // Possible Routes
    static let recommended = "recommended"

    // Google Directions API
    static let directionsApi = "https://maps.googleapis.com/maps/api/directions/json"
    static let directionsApiKey = "${GOOGLE_DIRECTIONS_API_KEY}"

    // MAP
    static let defaultPolylineColor = "#004696"
}
