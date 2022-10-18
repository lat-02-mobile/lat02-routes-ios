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

enum HomeSelectionStatus {
    case SELECTING_POINTS, SHOWING_POSSIBLE_ROUTES, SHOWING_ROUTE_DETAILS
}

class HomeViewController: UIViewController {

    let viewmodel = HomeViewModel()
    var locationManager = CLLocationManager()
    var zoom: Float = 15
    var homeSelectionStatus = HomeSelectionStatus.SELECTING_POINTS
    var availableTransports = [AvailableTransport]()

    @IBOutlet weak var labelHelper: UILabel!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let app = ConstantVariables.defaults.bool(forKey: ConstantVariables.deflaunchApp)
        if app {
            verifyCitySelectedApp()
        }
        initViewModel()
        setupViews()
        initializeTheLocationManager()
        setupMap()
        cityLocation()
    }

    func initViewModel() {
        self.viewmodel.runAlgorithm = { [weak self] in
            if let origin = self?.viewmodel.origin, let destination = self?.viewmodel.destination {

                let algOrigin = CLLocationCoordinate2D(latitude: origin.position.latitude,
                                                       longitude: origin.position.longitude)
                let algDestination = CLLocationCoordinate2D(latitude: destination.position.latitude,
                                                            longitude: destination.position.longitude)
                self?.availableTransports = Algorithm.shared.findAvailableRoutes(origin: algOrigin,
                                                                               destination: algDestination,
                                                                               lines: (self?.viewmodel.lineRoutes)!,
                                                                               minDistanceBtwPoints: Algorithm.minDistanceBtwPointsAndStops,
                                                                               minDistanceBtwStops: Algorithm.minDistanceBtwPointsAndStops)
                DispatchQueue.main.sync {
                    SVProgressHUD.dismiss()
                    self?.homeSelectionStatus = .SHOWING_POSSIBLE_ROUTES
                    self?.labelHelper.text = String.localizeString(localizedString: StringResources.routes)
                    self?.showPossibleRoutesBottomSheet()
                }
            }
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
        guard let citySelected = ConstantVariables.defaults.string(forKey: ConstantVariables.defCitySelected) else { return }
        guard citySelected.isEmpty else { return }

        let vc = CityPickerViewController()
        vc.isSettingsController = false
        show(vc, sender: nil)
    }

    func setupViews() {
        currentLocationButton.layer.cornerRadius = 25
        currentLocationButton.clipsToBounds = true

        backButton.layer.cornerRadius = 25
        backButton.clipsToBounds = true

        continueButton.layer.cornerRadius = 25
        continueButton.clipsToBounds = true

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
                return
            case.pendingDestination:
                labelHelper.text = String.localizeString(localizedString: StringResources.selectOrigin)
                viewmodel.pointsSelectionStatus = .pendingOrigin
                viewmodel.origin?.map = mapView
                viewmodel.origin?.map = nil
                viewmodel.origin = nil
                backButton.isHidden = true
            case.bothSelected:
                labelHelper.text = String.localizeString(localizedString: StringResources.selectDestination)
                viewmodel.pointsSelectionStatus = .pendingDestination
                viewmodel.destination?.map = mapView
                viewmodel.destination?.map = nil
                viewmodel.destination = nil
                viewmodel.selectedAvailableTransport = nil
                mapView.clear()
                viewmodel.origin?.map = mapView
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

    @IBAction func continueButtonAction(_ sender: Any) {
        let position = mapView.camera.target
        let pos = GMSMarker(position: position)

        switch viewmodel.pointsSelectionStatus {
        case.pendingOrigin:
            pos.title = String.localizeString(localizedString: StringResources.origin)
            labelHelper.text = String.localizeString(localizedString: StringResources.selectDestination)
            pos.icon = UIImage(named: ConstantVariables.originPoint)
            pos.map = mapView
            viewmodel.origin = pos
            viewmodel.pointsSelectionStatus = .pendingDestination

        case.pendingDestination:
            pos.title = String.localizeString(localizedString: StringResources.destination)
            labelHelper.text = String.localizeString(localizedString: StringResources.done)
            pos.icon = UIImage(named: ConstantVariables.destinationPoint)
            pos.map = mapView
            viewmodel.destination = pos
            viewmodel.pointsSelectionStatus = .bothSelected

        case.bothSelected:
            SVProgressHUD.show()
            continueButton.isHidden = true
            currentLocationButton.isHidden = true
            Toast.showToast(target: self, message: String.localizeString(localizedString: StringResources.loadingPossibleRoutes))
            if let origin = viewmodel.origin, let destination = viewmodel.destination {
                let distanceBetweenCoords = GoogleMapsHelper.shared.getDistanceBetween2Points(
                    origin: Coordinate(latitude: origin.position.latitude,
                                       longitude: origin.position.longitude),
                    destination: Coordinate(latitude: destination.position.latitude,
                                            longitude: destination.position.longitude))
                if distanceBetweenCoords <= 500.0 {
                    Toast.showToast(target: self, message: String.localizeString(localizedString: StringResources.youCanGoJustWalk))
                    SVProgressHUD.dismiss()
                } else {
                    Task.init {
                        try? await viewmodel.getLineRouteForCurrentCity()
                    }
                }
            }
        }
        backButton.isHidden = false
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
        if toLocation != nil {
            mapView.animate(to: GMSCameraPosition.camera(withTarget: toLocation!, zoom: zoom))
        }
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
