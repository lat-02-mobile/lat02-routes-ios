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

class HomeViewController: UIViewController {

    let viewmodel = HomeViewModel()
    var locationManager = CLLocationManager()
    @IBOutlet weak var labelHelper: UILabel!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    var zoom: Float = 15

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
//            print("origin latitude: \(self?.viewmodel.origin?.position.latitude)")
//            print("origin longitude: \(self?.viewmodel.origin?.position.longitude)")
//            print("destination latitude: \(self?.viewmodel.destination?.position.latitude)")
//            print("destination longitude: \(self?.viewmodel.destination?.position.longitude)")
            if let origin = self?.viewmodel.origin, let destination = self?.viewmodel.destination {
                let distanceBetweenCoords = GoogleMapsHelper.shared.getDistanceBetween2Points(
                    origin: Coordinate(latitude: origin.position.latitude,
                                       longitude: origin.position.longitude),
                    destination: Coordinate(latitude: destination.position.latitude,
                                            longitude: destination.position.longitude))
//                if distanceBetweenCoords <= 500.0 {
//                    DispatchQueue.main.sync {
//                        self?.showToast(message: "You can go to this route just walking")
//                        SVProgressHUD.dismiss()
//                    }
//                    return
//                }
                let algOrigin = CLLocationCoordinate2D(latitude: -17.395475,
                                                       longitude: -66.17532)
                let algDestination = CLLocationCoordinate2D(latitude: -17.398454,
                                                            longitude: -66.17588)
                let availableTransports = Algorithm.shared.findAvailableRoutes(origin: algOrigin,
                                                                               destination: algDestination,
                                                                               lines: (self?.viewmodel.lineRoutes)!,
                                                                               minDistanceBtwPoints: Algorithm.minDistanceBtwPointsAndStops,
                                                                               minDistanceBtwStops: Algorithm.minDistanceBtwPointsAndStops)
//                print("availableTransports: \(availableTransports.count)")
                DispatchQueue.main.sync {
                    SVProgressHUD.dismiss()
                    self?.labelHelper.text = "Route 1"
                    let viewModel = PossibleRoutesViewModel()
                    viewModel.map = self?.mapView
                    let viewController = BottomSheetViewController(viewModel: viewModel, possibleRoutes: availableTransports)
                    viewController.delegate = self
                    if let presentationController = viewController.presentationController as? UISheetPresentationController {
                        presentationController.detents = [.medium()]
                    }
                    self?.present(viewController, animated: true)
                }
            }
        }
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

        labelHelper.text = String.localizeString(localizedString: ConstantVariables.selectOrigin)
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
        switch viewmodel.pointsSelectionStatus {
        case.pendingOrigin:
            return
        case.pendingDestination:
            labelHelper.text = String.localizeString(localizedString: ConstantVariables.selectOrigin)
            viewmodel.pointsSelectionStatus = .pendingOrigin
            viewmodel.origin?.map = mapView
            viewmodel.origin?.map = nil
            viewmodel.origin = nil
            backButton.isHidden = true
        case.bothSelected:
            labelHelper.text = String.localizeString(localizedString: ConstantVariables.selectDestination)
            viewmodel.pointsSelectionStatus = .pendingDestination
            viewmodel.destination?.map = mapView
            viewmodel.destination?.map = nil
            viewmodel.destination = nil
            viewmodel.selectedAvailableTransport = nil
            mapView.clear()
            viewmodel.origin?.map = mapView
        }
    }

    @IBAction func continueButtonAction(_ sender: Any) {
        let position = mapView.camera.target
        let pos = GMSMarker(position: position)

        switch viewmodel.pointsSelectionStatus {
        case.pendingOrigin:
            pos.title = String.localizeString(localizedString: ConstantVariables.origin)
            labelHelper.text = String.localizeString(localizedString: ConstantVariables.selectDestination)
            pos.icon = UIImage(named: ConstantVariables.originPoint)
            pos.map = mapView
            viewmodel.origin = pos
            viewmodel.pointsSelectionStatus = .pendingDestination

        case.pendingDestination:
            pos.title = String.localizeString(localizedString: ConstantVariables.destination)
            labelHelper.text = String.localizeString(localizedString: ConstantVariables.done)
            pos.icon = UIImage(named: ConstantVariables.destinationPoint)
            pos.map = mapView
            viewmodel.destination = pos
            viewmodel.pointsSelectionStatus = .bothSelected

        case.bothSelected:
            // Call logic to run algorithm with routes
            SVProgressHUD.show()
            Toast.showToast(target: self, message: String.localizeString(localizedString: StringResources.loadingPossibleRoutes))
            Task.init {
                try? await viewmodel.getLineRouteForCurrentCity()
                print("data: \(viewmodel.lineRoutes)")
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
        let alertController = UIAlertController(title: String.localizeString(localizedString: ConstantVariables.localizationPermissionAlertTitle),
                                                message: String.localizeString(localizedString: ConstantVariables.localizationPermissionAlertMessage),
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title:
            String.localizeString(localizedString: ConstantVariables.localizationPermissionAlertSettings),
               style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
             }
        }
        let cancelAction = UIAlertAction(title:
                                            String.localizeString(localizedString: ConstantVariables.localizationPermissionAlertCancel),
             style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func showSearchPage(_ sender: Any) {
        if let selRoute = viewmodel.selectedAvailableTransport {
            showRouteDetail(selectedAvailableTransport: selRoute)
            return
        }

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
    }

    func showRouteDetail(selectedAvailableTransport: AvailableTransport) {
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
    func showSelectedRoute(selectedRoute: AvailableTransport) {
//        print("selected route: \(selectedRoute)")
        self.showRouteDetail(selectedAvailableTransport: selectedRoute)
        self.viewmodel.selectedAvailableTransport = selectedRoute
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
