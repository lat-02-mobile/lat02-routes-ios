//
//  HomeViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 2/8/22.
//

import UIKit
import GoogleMaps
import GooglePlaces

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
        setupViews()
        initializeTheLocationManager()
        setupMap()
        cityLocation()
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
            self.showToast(message: ConstantVariables.done)
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
      if let styleURL = Bundle.main.url(forResource: "silver-style", withExtension: "json") {
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

    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }

}

// MARK: SearchLocation Delegate
extension HomeViewController: SearchLocationDelegate {
    func onPlaceTap(location: CLLocationCoordinate2D) {
        self.cameraMoveToLocation(toLocation: location)
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
