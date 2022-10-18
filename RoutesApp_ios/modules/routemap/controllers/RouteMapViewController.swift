import UIKit
import GoogleMaps
import Firebase

class RouteMapViewController: UIViewController {
    private var zoom: Float = 15
    var linePath: LinePath!
    var locationManager = CLLocationManager()
    var currentPosition: CLLocationCoordinate2D?
    var isSettingsController = true
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        initializeTheLocationManager()
        setupMap()
        drawRoute()
        drawInitialMarkers()
        drawStopsMarkers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    private func setupMap() {
        if let styleURL = Bundle.main.url(forResource: "silver-style", withExtension: "json") {
          mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
          mapView.settings.zoomGestures = true
          mapView.settings.myLocationButton = true
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
    @IBAction func backButton(_ sender: Any) {
        guard isSettingsController else { return }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    private func drawRoute() {
        let path = GMSMutablePath()
        for route in linePath.routePoints {
            path.add(route.toCLLocationCoordinate2D())
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor =  UIColor(named: "primary-color") ?? .blue
        polyline.strokeWidth = 6
        polyline.map = mapView
        var bounds = GMSCoordinateBounds()
        for index in 1...path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 90.0))
    }
    private func drawStopsMarkers() {
        for stop in linePath.stops {
            let marker = GMSMarker()
            marker.icon = UIImage(named: "route-stop")
            marker.position = stop.toCLLocationCoordinate2D()
            marker.map = mapView
        }
    }
    private func drawInitialMarkers() {
        var marker = GMSMarker()
        marker.position = linePath.start.toCLLocationCoordinate2D()
        marker.title = String.localizeString(localizedString: "start")
        marker.icon = UIImage(named: "route-start")
        marker.map = mapView
        marker = GMSMarker()
        marker.position =  linePath.end.toCLLocationCoordinate2D()
        marker.icon = UIImage(named: "route-end")
        marker.title =  String.localizeString(localizedString: "end")
        marker.map = mapView
    }
   private func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
   private func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.animate(to: GMSCameraPosition.camera(withTarget: toLocation!, zoom: zoom))
            setCurrentLocationMarker()
        }
    }
    private func setCurrentLocationMarker() {
         let marker = GMSMarker()
         marker.position = currentPosition!
         marker.map = mapView
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

extension RouteMapViewController: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard CLLocationManager.locationServicesEnabled() else {
            locationManager.requestWhenInUseAuthorization()
            return false
        }
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            self.cameraMoveToLocation(toLocation: self.currentPosition)
        case .notDetermined, .restricted, .denied:
            self.showRequestPermissionsAlert()
        @unknown default:
            return false
        }
        return true
    }
}
extension RouteMapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentPosition = locationManager.location?.coordinate
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
