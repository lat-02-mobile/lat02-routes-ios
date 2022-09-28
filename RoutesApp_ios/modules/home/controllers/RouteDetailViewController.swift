//
//  RouteDetailViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 14/9/22.
//

import UIKit
import FirebaseFirestore
import GoogleMaps

protocol RouteDetailDelegate: AnyObject {
    func getLatitude() -> Double?
    func getLongitude() -> Double?
}

class RouteDetailViewController: UIViewController {
    @IBOutlet weak var linesTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    let mapView: GMSMapView!
    var routePath: [LinePath] = []
    let viewmodel = PopupRouteDetailViewModel()
    var delegate: RouteDetailDelegate?
    var isFavorite = false
    var currFav: FavoriteDest?
    init(map: GMSMapView) {
        self.mapView = map
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fake()
        print(viewmodel.getAllFavorites())
        // MARK: For populate the routes
        // MARK: Check if the selected destination is a favorite
        if let latitude = self.delegate?.getLatitude(), let longitude = self.delegate?.getLongitude() {
            if let nearestFav = viewmodel.getNearestFavDest(lat: latitude, lng: longitude) {
                currFav = nearestFav
                let nearestPoint = CLLocationCoordinate2D(latitude: Double(nearestFav.latitude!)!, longitude: Double(nearestFav.longitude!)!)
                isFavorite = true
                mapView.animate(to: GMSCameraPosition.camera(withTarget: nearestPoint, zoom: 17))
                self.favoriteButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            }
        }
    }
    @IBAction func saveAsFavorite(_ sender: Any) {
        if !isFavorite {
            showAddFavoriteDialog()
        } else {
            removeFromFavoritesDialog()
        }
    }
    private func setupViews() {
        linesTableView.delegate = self
        linesTableView.dataSource = self
        let nib = UINib(nibName: LinePathTableViewCell.linePathCellNib, bundle: nil)
        linesTableView.register(nib, forCellReuseIdentifier: LinePathTableViewCell.linePathCellIdentifier)
    }
    private func fake() {
        let startFake = Coordinate(latitude: -17.399995087026774, longitude: -66.20014299508014)
        var routePointsFake = [Coordinate]()
        routePointsFake.append(Coordinate(latitude: -17.398981250521075, longitude: -66.20007157263323))
        routePointsFake.append(Coordinate(latitude: -17.397810679492547, longitude: -66.1999545010346))
        routePointsFake.append(Coordinate(latitude: -17.3974338574844, longitude: -66.1999486028894))
        routePointsFake.append(Coordinate(latitude: -17.396893048470602, longitude: -66.1998799078331))
        routePointsFake.append(Coordinate(latitude: -17.396253908487335, longitude: -66.19981979966167))
        routePointsFake.append(Coordinate(latitude: -17.395852396326653, longitude: -66.1998026258956))
        routePointsFake.append(Coordinate(latitude: -17.395125848279477, longitude: -66.19974824231288))
        routePointsFake.append(Coordinate(latitude: -17.39457410684962, longitude: -66.1997024456059))
        routePointsFake.append(Coordinate(latitude: -17.393459693353595, longitude: -66.19967096037196))
        routePointsFake.append(Coordinate(latitude: -17.39291340974458, longitude: -66.19965951119255))
        routePointsFake.append(Coordinate(latitude: -17.39134172098523, longitude: -66.19954120916185))
        routePointsFake.append(Coordinate(latitude: -17.390341829145452, longitude: -66.19949201722072))
        routePointsFake.append(Coordinate(latitude: -17.389011012481777, longitude: -66.19936889269803))
        routePointsFake.append(Coordinate(latitude: -17.38785149821912, longitude: -66.19925575124743))
        routePointsFake.append(Coordinate(latitude: -17.386034754649195, longitude: -66.19914752899405))
        routePointsFake.append(Coordinate(latitude: -17.386046609524403, longitude: -66.19891988133985))
        routePointsFake.append(Coordinate(latitude: -17.386454200368377, longitude: -66.19826690448693))
        routePointsFake.append(Coordinate(latitude: -17.38663056151747, longitude: -66.19781105269574))
        routePointsFake.append(Coordinate(latitude: -17.386697186793345, longitude: -66.19775355787849))
        routePointsFake.append(Coordinate(latitude: -17.386912738994745, longitude: -66.19724021127081))
        routePointsFake.append(Coordinate(latitude: -17.387061665815008, longitude: -66.19673918498366))
        routePointsFake.append(Coordinate(latitude: -17.386971525911047, longitude: -66.19586444238386))
        routePointsFake.append(Coordinate(latitude: -17.38690490073507, longitude: -66.19514575716836))
        routePointsFake.append(Coordinate(latitude: -17.38704480007609, longitude: -66.19509586669943))
        routePointsFake.append(Coordinate(latitude: -17.387197896606338, longitude: -66.19511963363652))
        routePointsFake.append(Coordinate(latitude: -17.387536220579, longitude: -66.19517707040428))
        var routeStopsFake = [Coordinate]()
        routeStopsFake.append(Coordinate(latitude: -17.3974338574844, longitude: -66.1999486028894))
        let endFake = Coordinate(latitude: -17.387536220579, longitude: -66.19517707040428)
    }
    private func drawRoute(linePath: LinePath) {
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
    func showAddFavoriteDialog() {
        let alert = UIAlertController(
            title: String.localizeString(localizedString: "save-dest"),
            message: String.localizeString(localizedString: "choose-name-for-new-fav-dest"),
            preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) -> Void in
            textField.placeholder = String.localizeString(localizedString: "write-name")
        }
        alert.addAction(UIAlertAction(title: String.localizeString(localizedString: "save"), style: .default, handler: { _ in
            self.isFavorite = true
            if let textField = alert.textFields?.first, let favName = textField.text {
                self.favoriteButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
                if let latitude = self.delegate?.getLatitude(), let longitude = self.delegate?.getLongitude() {
                    self.viewmodel.saveDestination(latitude: latitude,
                                                   longitude: longitude,
                                                   name: favName)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: String.localizeString(localizedString: "cancel"), style: .default))
        present(alert, animated: true)
    }
    func removeFromFavoritesDialog() {
        let alert = UIAlertController(
            title: "\(String.localizeString(localizedString: "remove-fav-dest"))",
            message: "\(String.localizeString(localizedString: "sure-want-remove-fav-dest")) (\(self.currFav!.name ?? ""))",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String.localizeString(localizedString: "yes"), style: .default, handler: { _ in
            self.favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            if self.viewmodel.removeFavorite(favId: self.currFav!.id) {
                self.isFavorite = false
            }
        }))
        alert.addAction(UIAlertAction(title: String.localizeString(localizedString: "cancel"), style: .default))
        present(alert, animated: true)
    }
}

extension RouteDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        routePath.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LinePathTableViewCell.linePathCellIdentifier, for: indexPath)
            as? LinePathTableViewCell else { return UITableViewCell() }
        return cell
    }
}
