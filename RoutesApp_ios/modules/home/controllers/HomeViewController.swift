//
//  HomeViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 2/8/22.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController {

    let viewmodel = HomeViewModel()
    var locationManager = CLLocationManager()
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var currentLocationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initializeTheLocationManager()
        setupMap()
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

    @IBAction func currentLocationAction(_ sender: Any) {
        guard CLLocationManager.locationServicesEnabled() else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        // check the permission status
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorize.")
            self.locationManager.startUpdatingLocation()
            self.cameraMoveToLocation(toLocation: self.viewmodel.currentPosition)
        case .notDetermined, .restricted, .denied:
            // redirect the users to settings
            showRequestPermissionsAlert()
        default:
            print("Unathorized.")
        }
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
      }
    }

    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.animate(to: GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15))
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
}

extension HomeViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.viewmodel.currentPosition = locationManager.location?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}
