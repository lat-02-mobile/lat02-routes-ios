//
//  HomeViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 2/8/22.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import Kingfisher

enum HomeSelectionStatus {
    case SELECTING_POINTS, SHOWING_POSSIBLE_ROUTES, SHOWING_ROUTE_DETAILS
}

enum DestinationFromView {
    case TOURPOINTS, FAVORITES, NONE
}

class HomeViewController: UIViewController {

    let viewmodel = HomeViewModel()
    let settingPopupViewModel = SettingsPopupViewModel()
    let tourpointsViewModel = TourpointsViewModel()
    var tourpointsMarkers = [GMSMarker]()
    var locationManager = CLLocationManager()
    var zoom: Float = 15
    var homeSelectionStatus = HomeSelectionStatus.SELECTING_POINTS
    var availableTransports = [AvailableTransport]()

    private var destinationFromDifferentController = DestinationFromView.NONE
    private var destinationAux: CLLocationCoordinate2D?
    private let syncData = SyncData()
    private var originTourpoint: GMSMarker?
    private var destinationTourpoint: GMSMarker?
    
    @IBOutlet weak var labelHelper: UILabel!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var destinationContainer: UIView!
    @IBOutlet weak var destinationPreselectedTitle: UILabel!
    @IBOutlet weak var destinationPreselectedName: UILabel!
    @IBOutlet weak var settingsPopup: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let app = ConstantVariables.defaults.bool(forKey: ConstantVariables.deflaunchApp)
        if app {
            verifyCitySelectedApp()
        }
        initViewModel()
        updateLocalDataInfo()
        setupViews()
        initializeTheLocationManager()
        setupMap()
        cityLocation()
        getTourpoints()
        mapView.delegate = self
        showTourpointsMarkers()
    }

    func getTourpoints() {
        tourpointsViewModel.getTourpoints()
    }

    func initViewModel() {
        self.viewmodel.runAlgorithm = { [weak self] in
            guard let strongSelf = self else {return}
            if let origin = strongSelf.viewmodel.origin, let destination = strongSelf.viewmodel.destination {
                let algOrigin = CLLocationCoordinate2D(latitude: origin.position.latitude,
                                                       longitude: origin.position.longitude)
                let algDestination = CLLocationCoordinate2D(latitude: destination.position.latitude,
                                                            longitude: destination.position.longitude)
                strongSelf.availableTransports = Algorithm.shared.findAvailableRoutes(origin: algOrigin,
                                                                               destination: algDestination,
                                                                                lines: strongSelf.viewmodel.lineRoutes,
                                                                               minDistanceBtwPoints: Algorithm.minDistanceBtwPointsAndStops,
                                                                               minDistanceBtwStops: Algorithm.minDistanceBtwPointsAndStops)
                SVProgressHUD.dismiss()
                strongSelf.homeSelectionStatus = .SHOWING_POSSIBLE_ROUTES
                strongSelf.labelHelper.text = String.localizeString(localizedString: StringResources.routes)
                strongSelf.showPossibleRoutesBottomSheet()
            }
        }
    }
    func updateLocalDataInfo() {
        guard let citySelected = ConstantVariables.defaults.string(forKey: ConstantVariables.defCitySelected) else {return}
        if  !citySelected.isEmpty {
            syncData.syncData()
        }
    }

    func showPossibleRoutesBottomSheet() {
        let viewModel = PossibleRoutesViewModel()
        viewModel.map = mapView
        let viewController = BottomSheetViewController(viewModel: viewModel, possibleRoutes: availableTransports)
        viewController.delegate = self
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        self.present(viewController, animated: true)
    }

    func verifyCitySelectedApp() {
        let citySelected = ConstantVariables.defaults.string(forKey: ConstantVariables.defCitySelected)
        if citySelected == nil {
            let vc = CityPickerViewController()
            vc.isSettingsController = false
            show(vc, sender: nil)
        }
    }

    func setupViews() {
        currentLocationButton.layer.cornerRadius = 25
        currentLocationButton.clipsToBounds = true

        backButton.layer.cornerRadius = 25
        backButton.clipsToBounds = true

        continueButton.layer.cornerRadius = 25
        continueButton.clipsToBounds = true
        destinationContainer.layer.cornerRadius = 15

        searchButton.contentVerticalAlignment = .top

        labelHelper.text = String.localizeString(localizedString: StringResources.selectOrigin)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }

    func cityLocation() {
        let lat = ConstantVariables.defaults.double(forKey: ConstantVariables.defCityLat)
        let lng = ConstantVariables.defaults.double(forKey: ConstantVariables.defCityLong)
        if lat == 0, lng == 0 {
            verifyCitySelectedApp()
        } else {
            self.mapView.clear()
            DispatchQueue.main.async {
                let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                self.cameraMoveToLocation(toLocation: position)
            }
        }
    }

    func setDestinationPointFromOtherView(coordinates: Coordinate, comesFrom: DestinationFromView, withName: String) {
        destinationFromDifferentController = comesFrom
        let position = coordinates.toCLLocationCoordinate2D()
        destinationPreselectedTitle.text = String.localizeString(localizedString: StringResources.preSelectedDestination)
        destinationPreselectedName.text = withName
        destinationContainer.isHidden = false
        currentLocationAction(self)
        destinationAux = position
        continueButtonAction(self)
    }

    @IBAction func currentLocationAction(_ sender: Any) {
        guard CLLocationManager.locationServicesEnabled() else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        // check the permission status
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            self.cameraMoveToLocation(toLocation: self.viewmodel.currentPosition)
        case .notDetermined, .restricted, .denied:
            // redirect the users to settings
            showRequestPermissionsAlert()
        @unknown default:
            showRequestPermissionsAlert()
        }
    }

    @IBAction func zoomIn(_ sender: Any) {
        zoom += 1
        self.mapView.animate(toZoom: zoom)
    }

    @IBAction func zoomOut(_ sender: Any) {
        zoom -= 1
        self.mapView.animate(toZoom: zoom)
    }

    @IBAction func backButtonAction(_ sender: Any) {
        switch homeSelectionStatus {
        case .SELECTING_POINTS:
            switch viewmodel.pointsSelectionStatus {
            case.pendingOrigin:
                if destinationFromDifferentController != .NONE {
                    backButton.isHidden = true
                    destinationAux = nil
                    removeMarkerResetStatusAndLabel(isForOrigin: false, status: .pendingOrigin, label: StringResources.selectOrigin)
                    gotToTab()
                    destinationFromDifferentController = .NONE
                }
            case.pendingDestination:
                if destinationFromDifferentController == .NONE {
                    removeMarkerResetStatusAndLabel(isForOrigin: true, status: .pendingOrigin, label: StringResources.selectOrigin)
                    backButton.isHidden = true
                }
            case.bothSelected:
                destinationFromDifferentController != .NONE ?
                removeMarkerResetStatusAndLabel(isForOrigin: true, status: .pendingOrigin, label: StringResources.selectOrigin) :
                removeMarkerResetStatusAndLabel(isForOrigin: false, status: .pendingDestination, label: StringResources.selectDestination)
                viewmodel.selectedAvailableTransport = nil
            }
        case .SHOWING_POSSIBLE_ROUTES:
            continueButton.isHidden = false
            currentLocationButton.isHidden = false
            labelHelper.text = String.localizeString(localizedString: StringResources.done)
            homeSelectionStatus = .SELECTING_POINTS
        case .SHOWING_ROUTE_DETAILS:
            mapView.clear()
            viewmodel.origin?.map = mapView
            viewmodel.destination?.map = mapView
            labelHelper.text = String.localizeString(localizedString: StringResources.routes)
            homeSelectionStatus = .SHOWING_POSSIBLE_ROUTES
        }
    }

    private func gotToTab() {
        destinationContainer.isHidden = true
        let tabViewController = SceneDelegate.shared?.window?.rootViewController as? UITabBarController
        guard let tabController = tabViewController else { return }
        switch destinationFromDifferentController {
        case .TOURPOINTS:
            tabController.selectedIndex = ConstantVariables.TourpointPageIndex
        case .FAVORITES:
            tabController.selectedIndex = ConstantVariables.FavoritesPageIndex
        case .NONE:
            return
        }
    }

    private func removeMarkerResetStatusAndLabel(isForOrigin: Bool, status: PointsSelectionStatus, label: String) {
        labelHelper.text = String.localizeString(localizedString: label)
        viewmodel.pointsSelectionStatus = status
        if isForOrigin {
            viewmodel.origin?.map = mapView
            viewmodel.origin?.map = nil
            viewmodel.origin = nil
            if originTourpoint != nil {
                guard let marker = originTourpoint else { return }
                marker.map = mapView
                originTourpoint = nil
            }
        } else {
            viewmodel.destination?.map = mapView
            viewmodel.destination?.map = nil
            viewmodel.destination = nil
            if destinationTourpoint != nil {
                guard let marker = destinationTourpoint else { return }
                marker.map = mapView
                destinationTourpoint = nil
            }
        }
    }

    @IBAction func continueButtonAction(_ sender: Any) {
        let position: CLLocationCoordinate2D
        if destinationFromDifferentController != .NONE && viewmodel.destination == nil {
            guard let destinationAux = destinationAux else { return }
            position = destinationAux
            viewmodel.pointsSelectionStatus = .pendingDestination
        } else {
            position = mapView.camera.target
        }
        let pos = GMSMarker(position: position)
        switch viewmodel.pointsSelectionStatus {
        case.pendingOrigin:
            pos.title = String.localizeString(localizedString: StringResources.origin)
            pos.icon = UIImage(named: ConstantVariables.originPoint)
            pos.map = mapView
            viewmodel.origin = pos
            destinationFromDifferentController != .NONE ?
            setHelperLabelAndStatus(label: StringResources.done, status: .bothSelected) :
            setHelperLabelAndStatus(label: StringResources.selectDestination, status: .pendingDestination)

        case.pendingDestination:
            pos.title = String.localizeString(localizedString: StringResources.destination)
            pos.icon = UIImage(named: ConstantVariables.destinationPoint)
            pos.map = mapView
            viewmodel.destination = pos
            destinationFromDifferentController != .NONE ?
            setHelperLabelAndStatus(label: StringResources.selectOrigin, status: .pendingOrigin) :
            setHelperLabelAndStatus(label: StringResources.done, status: .bothSelected)

        case.bothSelected:
            Toast.showToast(target: self, message: String.localizeString(localizedString: StringResources.loadingPossibleRoutes))
            guard let origin = viewmodel.origin, let destination = viewmodel.destination else { return }
            let distanceBetweenCoords = GoogleMapsHelper.shared.getDistanceBetween2Points(
                    origin: Coordinate(latitude: origin.position.latitude, longitude: origin.position.longitude),
                    destination: Coordinate(latitude: destination.position.latitude, longitude: destination.position.longitude))
            if distanceBetweenCoords <= 500.0 {
                Toast.showToast(target: self, message: String.localizeString(localizedString: StringResources.youCanGoJustWalk))
            } else {
                continueButton.isHidden = true
                currentLocationButton.isHidden = true
                SVProgressHUD.show()
                viewmodel.getLineRouteForCurrentCity()
            }
        }
        backButton.isHidden = false
    }

    private func setHelperLabelAndStatus(label: String, status: PointsSelectionStatus) {
        labelHelper.text = String.localizeString(localizedString: label)
        viewmodel.pointsSelectionStatus = status
    }

    func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }

    func setupMap() {
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        if let styleURL = Bundle.main.url(forResource: ConstantVariables.mapStyle, withExtension: ConstantVariables.mapStyleExt) {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
            mapView.settings.zoomGestures = true
        }
    }

    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        guard let location = toLocation else { return }
        mapView.animate(to: GMSCameraPosition.camera(withTarget: location, zoom: zoom))
    }

    private func showRequestPermissionsAlert() {
        let alertController = UIAlertController(title: String.localizeString(localizedString: StringResources.localizationPermissionAlertTitle),
                                                message: String.localizeString(localizedString: StringResources.localizationPermissionAlertMessage),
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title:
            String.localizeString(localizedString: StringResources.localizationPermissionAlertSettings),
               style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
             }
        }
        let cancelAction = UIAlertAction(title:
                                            String.localizeString(localizedString: StringResources.localizationPermissionAlertCancel),
             style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func showSearchPage(_ sender: Any) {
        switch homeSelectionStatus {
        case .SELECTING_POINTS:
            let latSW = mapView.projection.visibleRegion().nearRight.latitude
            let lonSW = mapView.projection.visibleRegion().farLeft.longitude

            let latNE = mapView.projection.visibleRegion().farLeft.latitude
            let lonNE = mapView.projection.visibleRegion().nearRight.longitude

            let northEast = CLLocationCoordinate2DMake(latNE, lonNE)
            let southWest = CLLocationCoordinate2DMake(latSW, lonSW)

            let filterLocation = GMSPlaceRectangularLocationOption(northEast, southWest)

            let viewController = SearchLocationViewController(placeBias: filterLocation, selectionStatus: viewmodel.pointsSelectionStatus)
            viewController.delegate = self

            if let presentationController = viewController.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }

            self.present(viewController, animated: true)
        case .SHOWING_POSSIBLE_ROUTES:
            if !availableTransports.isEmpty {
                showPossibleRoutesBottomSheet()
            }
        case .SHOWING_ROUTE_DETAILS:
            if let selRoute = viewmodel.selectedAvailableTransport {
                showRouteDetail(selectedAvailableTransport: selRoute)
                return
            }
        }
    }

    @IBAction func settingsPopupTapped(_ sender: Any) {
        let settingsPopup = SettingsPopupViewController()
        settingsPopup.homeVC = self

        if let presentationController = settingsPopup.presentationController as? UISheetPresentationController {
            presentationController.detents = [.large()]
        }
        self.present(settingsPopup, animated: true)
    }

    func showRouteDetail(selectedAvailableTransport: AvailableTransport) {
        homeSelectionStatus = .SHOWING_ROUTE_DETAILS
        mapView.clear()
        viewmodel.origin?.map = mapView
        viewmodel.destination?.map = mapView
        let viewController = RouteDetailViewController(map: self.mapView, routePath: selectedAvailableTransport)
        viewController.delegate = self
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }

        self.present(viewController, animated: true)
    }

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

