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
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
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

        let burguerButton = UIButton(type: .custom)
        burguerButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        burguerButton.backgroundColor = currentLocationButton.tintColor
        burguerButton.tintColor = .white
        burguerButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        burguerButton.layer.cornerRadius = burguerButton.frame.size.height / 2
        burguerButton.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(burgerButtonAction))
        burguerButton.addGestureRecognizer(tap)

        let counterButtonItem = UIBarButtonItem(customView: burguerButton)
        navigationItem.leftBarButtonItems = [counterButtonItem]
    }

    @objc func burgerButtonAction() {
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
        let alertController = UIAlertController(title: String.localizeString(localizedString: "localization-permission-alert-title"),
            message: String.localizeString(localizedString: "localization-permission-alert-message"), preferredStyle: .alert)

        let settingsAction = UIAlertAction(title:
            String.localizeString(localizedString: "localization-permission-alert-settings"),
               style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
             }
        }
        let cancelAction = UIAlertAction(title:
            String.localizeString(localizedString: "localization-permission-alert-cancel"),
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

        let viewController = SearchLocationViewController(placeBias: filterLocation)

        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }

        self.present(viewController, animated: true)
    }

}

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
