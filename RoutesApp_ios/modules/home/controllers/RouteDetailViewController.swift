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
    func getOrigin() -> Coordinate?
    func getDestination() -> Coordinate?
}

class RouteDetailViewController: UIViewController {
    @IBOutlet weak var linesTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    let mapView: GMSMapView!
    var possibleRoutesViewModel = PossibleRoutesViewModel()
    var walkingPathDistances = [Double?]()
    let viewmodel = PopupRouteDetailViewModel()
    var delegate: RouteDetailDelegate?
    var isFavorite = false
    var currFav: FavoriteDest?
    lazy var geocoder = CLGeocoder()
    var routePath: AvailableTransport
    // MARK: The following variable are only for test purposes. Delete these when refactor for official code
//    var routePath = AvailableTransport(connectionPoint: 8, transports: [
//        LineRoute(
//            name: "Ruta de ida", id: "12", idLine: "fds", line: "Line 3",
//            routePoints: [
//                Coordinate(latitude: -17.398981250521075, longitude: -66.20007157263323),
//                Coordinate(latitude: -17.397810679492547, longitude: -66.1999545010346),
//                Coordinate(latitude: -17.3974338574844, longitude: -66.1999486028894),
//                Coordinate(latitude: -17.396893048470602, longitude: -66.1998799078331),
//                Coordinate(latitude: -17.396253908487335, longitude: -66.19981979966167),
//                Coordinate(latitude: -17.395852396326653, longitude: -66.1998026258956),
//                Coordinate(latitude: -17.395125848279477, longitude: -66.19974824231288),
//                Coordinate(latitude: -17.39457410684962, longitude: -66.1997024456059),
//                Coordinate(latitude: -17.393459693353595, longitude: -66.19967096037196),
//                Coordinate(latitude: -17.39291340974458, longitude: -66.19965951119255),
//                Coordinate(latitude: -17.39134172098523, longitude: -66.19954120916185),
//                Coordinate(latitude: -17.390341829145452, longitude: -66.19949201722072),
//                Coordinate(latitude: -17.389011012481777, longitude: -66.19936889269803),
//                Coordinate(latitude: -17.38785149821912, longitude: -66.19925575124743),
//                Coordinate(latitude: -17.386034754649195, longitude: -66.19914752899405),
//                Coordinate(latitude: -17.386046609524403, longitude: -66.19891988133985),
//                Coordinate(latitude: -17.386454200368377, longitude: -66.19826690448693),
//                Coordinate(latitude: -17.38663056151747, longitude: -66.19781105269574),
//                Coordinate(latitude: -17.386697186793345, longitude: -66.19775355787849),
//                Coordinate(latitude: -17.386912738994745, longitude: -66.19724021127081),
//                Coordinate(latitude: -17.387061665815008, longitude: -66.19673918498366),
//                Coordinate(latitude: -17.386971525911047, longitude: -66.19586444238386),
//                Coordinate(latitude: -17.38690490073507, longitude: -66.19514575716836),
//                Coordinate(latitude: -17.38704480007609, longitude: -66.19509586669943),
//                Coordinate(latitude: -17.387197896606338, longitude: -66.19511963363652),
//                Coordinate(latitude: -17.387536220579, longitude: -66.19517707040428)
//            ],
//            start: Coordinate(latitude: -17.399995087026774, longitude: -66.20014299508014),
//            stops: [Coordinate(latitude: -17.3974338574844, longitude: -66.1999486028894)],
//            end: Coordinate(latitude: -17.387536220579, longitude: -66.19517707040428),
//            averageVelocity: 3.2,
//            blackIcon: "https://firebasestorage.googleapis.com/v0/b/routes-app-8c8e4.appspot.com/o/lineCategories%2Fcable_way_black.png?alt=media&token=d43f6279-265c-4a56-bf61-6579c2e9c391",
//            whiteIcon: "https://firebasestorage.googleapis.com/v0/b/routes-app-8c8e4.appspot.com/o/lineCategories%2Fcable_way_white.png?alt=media&token=98c4cf19-fb19-40a2-af4c-8f4e67b0f5f5",
//            color: "#67F5ED"
//        ),
//        LineRoute(
//            name: "Ruta de vuelta",
//            id: "12",
//            idLine: "fds",
//            line: "Line E",
//            routePoints: [
//                Coordinate(latitude: -17.395167, longitude: -66.176963),
//                Coordinate(latitude: -17.395274, longitude: -66.176126),
//                Coordinate(latitude: -17.395371, longitude: -66.175389),
//                Coordinate(latitude: -17.395411, longitude: -66.175333),
//                Coordinate(latitude: -17.395475, longitude: -66.17532),
//                Coordinate(latitude: -17.395734, longitude: -66.175376),
//                Coordinate(latitude: -17.396059, longitude: -66.175451),
//                Coordinate(latitude: -17.396532, longitude: -66.175538),
//                Coordinate(latitude: -17.398454, longitude: -66.17588),
//                Coordinate(latitude: -17.400233, longitude: -66.176186),
//                Coordinate(latitude: -17.400479, longitude: -66.176159),
//                Coordinate(latitude: -17.400772, longitude: -66.17629),
//                Coordinate(latitude: -17.400631, longitude: -66.176977),
//                Coordinate(latitude: -17.400851, longitude: -66.177095),
//                Coordinate(latitude: -17.400964, longitude: -66.177234),
//                Coordinate(latitude: -17.400969, longitude: -66.177433),
//                Coordinate(latitude: -17.400923, longitude: -66.177607)
//            ],
//            start: Coordinate(latitude: -17.395167, longitude: -66.176963),
//            stops: [Coordinate(latitude: -17.396059, longitude: -66.175451)],
//            end: Coordinate(latitude: -17.400923, longitude: -66.177607),
//            averageVelocity: 3.2,
//            blackIcon: "https://firebasestorage.googleapis.com/v0/b/routes-app-8c8e4.appspot.com/o/lineCategories%2Fcable_way_black.png?alt=media&token=d43f6279-265c-4a56-bf61-6579c2e9c391",
//            whiteIcon: "https://firebasestorage.googleapis.com/v0/b/routes-app-8c8e4.appspot.com/o/lineCategories%2Fcable_way_white.png?alt=media&token=98c4cf19-fb19-40a2-af4c-8f4e67b0f5f5",
//            color: "#67F5ED"
//        )
//    ])
    init(map: GMSMapView, routePath: AvailableTransport?, isJustWalking: Bool = false) {
        self.routePath = routePath!
        self.mapView = map
        super.init(nibName: nil, bundle: nil)
    }
    required init(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        drawMarkers()
        getRoutePathDetails()
        fitMapRoutePath()
        getStreetName()
        checkIfFavorite()
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

    private func checkIfFavorite() {
        if let latitude = self.delegate?.getDestination()?.latitude,
           let longitude = self.delegate?.getDestination()?.longitude {
            if let nearestFav = viewmodel.getNearestFavDest(lat: latitude, lng: longitude) {
                currFav = nearestFav
                let nearestPoint = CLLocationCoordinate2D(latitude: Double(nearestFav.latitude!)!, longitude: Double(nearestFav.longitude!)!)
                isFavorite = true
                mapView.animate(to: GMSCameraPosition.camera(withTarget: nearestPoint, zoom: 17))
                self.favoriteButton.setImage(UIImage(
                    systemName: "heart.fill")?
                    .withTintColor(UIColor(named: ConstantVariables.primaryColor)!,
                                   renderingMode: .alwaysOriginal),
                                             for: .normal)
            }
        }
    }

    private func drawMarkers() {
        guard let firstStop = routePath.transports.first?.routePoints.first,
              let lastStop = routePath.transports.last?.routePoints.last else { return }
        GoogleMapsHelper.shared.addCustomMarker(map: mapView, position: firstStop, icon: UIImage(named: ConstantVariables.startMarkerName))
        GoogleMapsHelper.shared.addCustomMarker(map: mapView, position: lastStop, icon: UIImage(named: ConstantVariables.endMarkerName))
    }

    private func getStreetName() {
        guard let origin = delegate?.getOrigin(), let destination = delegate?.getDestination() else { return }

        // MARK: The following variables are used for test purposes
//        let locationDestination = CLLocation(latitude: -17.40157915826933, longitude: -66.17522176355124)
//        let locationOrigin = CLLocation(latitude: -17.395577469672943, longitude: -66.17612667381763)

        let locationDestination = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let locationOrigin = CLLocation(latitude: origin.latitude, longitude: origin.longitude)

        // Geocode Location
        geocoder.reverseGeocodeLocation(locationOrigin) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error, labelTarget: self.originLabel)
            self.geocoder.reverseGeocodeLocation(locationDestination) { (placemarks, error) in
                // Process Response
                self.processResponse(withPlacemarks: placemarks, error: error, labelTarget: self.destinationLabel)
            }
        }
    }

    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?, labelTarget: UILabel) {
        if let error = error {
            labelTarget.text = String.localizeString(localizedString: StringResources.routeDetailUnableToGetLocation) + error.localizedDescription
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                labelTarget.text = placemark.singleStreetAddress
            } else {
                labelTarget.text = String.localizeString(localizedString: StringResources.routeDetailNoMatchesAdresses)
            }
        }
    }

    private func getRoutePathDetails() {
        if !routePath.transports.isEmpty {
            guard let origin = delegate?.getOrigin(), let destination = delegate?.getDestination() else { return }
            // Insert all walking paths between each route
            for i in stride(from: 0, to: routePath.transports.count - 1, by: 2) where i < routePath.transports.count - 1 {
                routePath.transports.insert(LineRoute.getWalkLineRoute(routePoints: [routePath.transports[i].routePoints.last! as Coordinate,
                    routePath.transports[i + 1].routePoints.first! as Coordinate]), at: i + 1)
            }

            // MARK: The following code is used for test purposes
//            routePath.transports.insert(LineRoute.getWalkLineRoute(routePoints: [
//                Coordinate(latitude: -17.395577469672943, longitude: -66.17612667381763),
//                (routePath.transports.first?.routePoints.first)! as Coordinate]), at: 0)

            routePath.transports.insert(LineRoute.getWalkLineRoute(routePoints: [
                origin, (routePath.transports.first?.routePoints.first)! as Coordinate]), at: 0)

            // MARK: The following code is used for test purposes
//            routePath.transports.append(LineRoute.getWalkLineRoute(routePoints: [
//                (routePath.transports.last?.routePoints.last)! as Coordinate,
//                Coordinate(latitude: -17.40157915826933, longitude: -66.17522176355124)
//            ]))

            routePath.transports.append(LineRoute.getWalkLineRoute(routePoints: [
                (routePath.transports.last?.routePoints.last)! as Coordinate, destination
            ]))

            walkingPathDistances = Array(repeating: nil, count: routePath.transports.count)
            // Drawing all the paths in the map
            for i in 0...routePath.transports.count - 1 {
                let lineRoute = routePath.transports[i]
                if lineRoute.name != LineRoute.lineWalkName {
                    if i > 1 {
                        GoogleMapsHelper.shared.addCustomMarker(map: mapView,
                                                                position: lineRoute.routePoints.first!,
                                                                icon: UIImage(named: ConstantVariables.stopMarkerName))
                    }
                    if i < routePath.transports.count - 2 {
                        GoogleMapsHelper.shared.addCustomMarker(map: mapView,
                                                                position: lineRoute.routePoints.last!,
                                                                icon: UIImage(named: ConstantVariables.stopMarkerName))
                    }
                }
                if lineRoute.line == LineRoute.lineWalkName {
                    possibleRoutesViewModel.getDirections(origin: lineRoute.routePoints[0], destination: lineRoute.routePoints[1]) { path in
                        GoogleMapsHelper.shared.drawDotPolyline(map: self.mapView, path: path)
                        self.walkingPathDistances[i] = (GoogleMapsHelper.shared.getGMSPathDistance(path: path))
                        self.linesTableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .fade)
                    }
                } else {
                    GoogleMapsHelper.shared.drawPolyline(map: mapView, list: lineRoute.routePoints, hexColor: lineRoute.color)
                }
            }
            linesTableView.reloadData()
        }
    }

    private func fitMapRoutePath() {
        let path = GMSMutablePath()
        routePath.transports.forEach { lineRoute in
            lineRoute.routePoints.forEach({ path.add($0.toCLLocationCoordinate2D()) })
        }
        var bounds = GMSCoordinateBounds()
        for index in 1...path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 110.0))
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
                self.favoriteButton.setImage(UIImage(
                    systemName: "heart.fill")?
                    .withTintColor(UIColor(named: ConstantVariables.primaryColor)!,
                                   renderingMode: .alwaysOriginal),
                                             for: .normal)
                if let latitude = self.delegate?.getDestination()?.latitude,
                   let longitude = self.delegate?.getDestination()?.longitude {
                    self.viewmodel.saveDestination(latitude: latitude,
                                                   longitude: longitude,
                                                   name: favName)
                    if let nearestFav = self.viewmodel.getNearestFavDest(lat: latitude, lng: longitude) {
                        self.currFav = nearestFav
                    }
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
            self.favoriteButton.setImage(UIImage(
                systemName: "heart")?
                .withTintColor(UIColor(named: ConstantVariables.primaryColor)!,
                               renderingMode: .alwaysOriginal),
                                         for: .normal)
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
        routePath.transports.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LinePathTableViewCell.linePathCellIdentifier, for: indexPath)
            as? LinePathTableViewCell else { return UITableViewCell() }
        if routePath.transports[indexPath.row].line == LineRoute.lineWalkName, let walkDist = walkingPathDistances[indexPath.row] {
            cell.setData(line: self.routePath.transports[indexPath.row], distance: walkDist)
        } else {
            cell.setData(line: routePath.transports[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
