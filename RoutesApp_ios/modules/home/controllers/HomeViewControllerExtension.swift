//
//  HomeViewControllerExtension.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/11/22.
//

import Foundation
import GoogleMaps
import Kingfisher

// MARK: ShowPossibleRoutes Delegate
extension HomeViewController: BottomSheetDelegate {
    func showSelectedRoute(selectedRoute: AvailableTransport, index: Int) {
        self.viewmodel.selectedAvailableTransport = selectedRoute
        labelHelper.text = String.localizeString(localizedString: StringResources.route) + " \(index + 1)"
        self.showRouteDetail(selectedAvailableTransport: selectedRoute)
    }
}

// MARK: SearchLocation Delegate
extension HomeViewController: SearchLocationDelegate {
    func onPlaceTap(location: CLLocationCoordinate2D) {
        self.cameraMoveToLocation(toLocation: location)
    }
}

// MARK: RouteDetail Delegate
extension HomeViewController: RouteDetailDelegate {
    func getOrigin() -> Coordinate? {
        if let origin = viewmodel.origin {
            return Coordinate(latitude: origin.position.latitude, longitude: origin.position.longitude)
        }
        return nil
    }

    func getDestination() -> Coordinate? {
        if let destination = viewmodel.destination {
            return Coordinate(latitude: destination.position.latitude, longitude: destination.position.longitude)
        }
        return nil
    }
}

// MARK: CLLocationManager Delegate
extension HomeViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.viewmodel.currentPosition = locationManager.location?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}

extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let markerPosition = marker.position
        self.cameraMoveToLocation(toLocation: markerPosition)
        self.mapView?.selectedMarker = marker
        let markerHint =  marker.accessibilityHint
        switch markerHint {
        case ConstantVariables.tourpointName:
            self.mapView?.selectedMarker?.map = nil
            let position = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
            self.changeTourpointToOriginOrDestination(position: position, tourpointMarker: marker)
        default:
            return true
        }
        return true
    }
}

extension HomeViewController {
    func showTourpointsMarkers() {
        let tourpoints = tourpointsViewModel.tourpointList
        guard tourpointsMarkers.isEmpty else {tourpointsMarkers.forEach({
            $0.map = mapView
        })
            return }

        tourpoints.map({ tourpoint in
            let marker = GMSMarker(position: tourpoint.destination.toCLLocationCoordinate2D())
            getTourpointIcon(with: tourpoint.category.icon, imageCompletionHandler: { image in
                marker.icon = image
                marker.title = tourpoint.name
                marker.accessibilityHint =  ConstantVariables.tourpointName
                marker.snippet = tourpoint.category.descriptionEng
                marker.map = self.mapView
                self.tourpointsMarkers.append(marker)
            })
        })
    }

    func getTourpointIcon(with urlString: String, imageCompletionHandler: @escaping (UIImage?) -> Void) {
            guard let url = URL.init(string: urlString) else {
                return  imageCompletionHandler(nil)
            }
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    imageCompletionHandler(value.image.resized(to: CGSize(width: 30, height: 40)))
                case .failure:
                    imageCompletionHandler(nil)
                }
            }
        }

    func hideTourpointsMarkers() {
        tourpointsMarkers.forEach({
            $0.map = nil
        })
    }
    func changeTourpointToOriginOrDestination(position: CLLocationCoordinate2D, tourpointMarker: GMSMarker) {
        let pos = GMSMarker(position: position)
        switch viewmodel.pointsSelectionStatus {
        case.pendingOrigin:
            pos.title = String.localizeString(localizedString: StringResources.origin)
            pos.icon = UIImage(named: ConstantVariables.originPoint)
            pos.map = mapView
            viewmodel.origin = pos
            self.originTourpoint = tourpointMarker
            destinationFromDifferentController != .NONE ?
            setHelperLabelAndStatus(label: StringResources.done, status: .bothSelected) :
            setHelperLabelAndStatus(label: StringResources.selectDestination, status: .pendingDestination)
        case.pendingDestination:
            pos.title = String.localizeString(localizedString: StringResources.destination)
            pos.icon = UIImage(named: ConstantVariables.destinationPoint)
            pos.map = mapView
            viewmodel.destination = pos
            self.destinationTourpoint = tourpointMarker
            destinationFromDifferentController != .NONE ?
            setHelperLabelAndStatus(label: StringResources.selectOrigin, status: .pendingOrigin) :
            setHelperLabelAndStatus(label: StringResources.done, status: .bothSelected)
        case .bothSelected:
            backButton.isHidden = false
        }
        backButton.isHidden = false
    }
}
