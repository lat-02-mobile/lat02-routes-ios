//
//  ConstantVariables.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 9/8/22.
//

import Foundation

enum Units: String {
    case meters
    case kilometers
    case minutes
}
enum Environment: String {
    case development = "Development"
    case production = "Production"
    case none = "None"
}
class ConstantVariables {
    static let databaseName = "RoutesApp_ios"
    static let cityCellNib = "CityTableViewCell"
    static let cityCellIdentifier = "CityCell"
    static let defaults = UserDefaults.standard
    static let deflaunchApp = "LaunchFirstTime"
    static let defCitySelected = "CitySelected"
    static let defCityLat = "CityLatitude"
    static let defCityLong = "CityLongitude"
    static let defCityId = "CityId"
    static let defUserLoggedId = "LoggedUserId"
    static let defUserType = "LoggedUserType"

    // Resources
    static let primaryColor = "primary-color"
    static let mapStyle = "silver-style"
    static let mapStyleExt = "json"
    static let filterIcon = "filter-icon"
    static let routeListCell = "RouteListTableViewCell"
    static let routeTitle = "routeTitle"
    static let lineRouteCell = "LineRouteTableViewCell"

    // PlaceTableViewCell
    static let placeCellNib = "PlaceTableViewCell"
    static let placeCellIdentifier = "PlaceCell"

    // image names
    static let destinationPoint = "destination_point"
    static let originPoint = "origin_point"

    // localized strings
    static let search = "search-bar"

    static let spanishLocale = "es"

    static let edit = "edit"
    static let delete = "delete"
    static let cancel = "cancel"
    static let save = "save"

    static let origin = "origin"
    static let selectOrigin = "select-origin"
    static let selectDestination = "select-destination"
    static let destination = "destination"
    static let done = "done"

    static let localizationPermissionAlertTitle = "localization-permission-alert-title"
    static let localizationPermissionAlertMessage = "localization-permission-alert-message"
    static let localizationPermissionAlertSettings = "localization-permission-alert-settings"
    static let localizationPermissionAlertCancel = "localization-permission-alert-cancel"
    static let routeDetailUnableToGetLocation = "route-detail-unable-to-get-location"
    static let routeDetailNoMatchesAdresses = "route-detail-no-matches-adressess"

    static let errorUpdatingData = "error-updating-data"

    static let editFavAlertTitle = "edit-fav"
    static let deleteFavAlertTitle = "remove-fav-dest"
    static let removeAlerMessage = "sure-want-remove-fav-dest"
    static let saveDestAlertTitle = "save-dest"
    static let updateAlertMessage = "new-name-for-fav-dest"
    static let favDestPlaceholder = "write-name"

    // Google Maps helper
    static let polylinePadding = 80
    static let originMarkerName = "origin_point"
    static let destinationMarkerName = "destination_point"
    static let stopMarkerName = "route-stop"
    static let endMarkerName = "route-end"
    static let startMarkerName = "route-start"
    static let localizationLinesFilterTitle = "filter-title"

    // Possible Routes
    static let recommended = "recommended"

    // Google Directions API
    static let directionsApi = "https://maps.googleapis.com/maps/api/directions/json"
    static let directionsApiKey = Env.GOOGLE_DIRECTIONS_API_KEY

    // MAP
    static let defaultPolylineColor = "#004696"

    // Units
    static func valueWithUnit(unit localizedString: Units, value: String) -> String {
        return String.localizedStringWithFormat(NSLocalizedString(localizedString.rawValue, comment: ""), value)
    }

    // app tab indexes
    static let LinesPageIndex = 0
    static let TourpointPageIndex = 1
    static let HomePageIndex = 2
    static let FavoritesPageIndex = 3
    static let ConfigurationPageIndex = 4
}
