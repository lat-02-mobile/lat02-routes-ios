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
    func drawRouteDetail()
}

class RouteDetailViewController: UIViewController {
//    var linePath: LinePath!
    @IBOutlet weak var linesTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    let mapView: GMSMapView!
    var routePath = AvailableTransport(connectionPoint: 8, transports: [])
    init(map: GMSMapView) {
        self.mapView = map
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fake()
        if !routePath.transports.isEmpty {
//            routePath.transports.forEach { lineRoute in
//                drawRoute(lineRoute: lineRoute)
//            }
            for i in stride(from: 0, to: routePath.transports.count - 1, by: 2) where i < routePath.transports.count - 1 {
                routePath.transports.insert(LineRoute(
                    name: "Walk",
                    id: "12",
                    idLine: "fds",
                    line: "Walk",
                    routePoints: [routePath.transports[i].routePoints.last! as Coordinate,
                                  routePath.transports[i + 1].routePoints.first! as Coordinate],
                    start: Coordinate(latitude: 0, longitude: 0),
                    stops: [],
                    end: Coordinate(latitude: 0, longitude: 0),
                    averageVelocity: 5.4
                ), at: i + 1)
            }
            print("Qt trans after: \(routePath.transports.count)")
            print("Walk: \(routePath.transports[1])")
            linesTableView.reloadData()
            routePath.transports.forEach { lineRoute in
                drawRoute(lineRoute: lineRoute)
            }
        }
    }
    @IBAction func saveAsFavorite(_ sender: Any) {
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
        let lineRoute1 = LineRoute(
            name: "Ruta de ida", id: "12", idLine: "fds", line: "Line 3",
            routePoints: routePointsFake,
            start: startFake,
            stops: routeStopsFake,
            end: endFake,
            averageVelocity: 5.4
        )
        self.routePath.transports.append(lineRoute1)
        // Second path
//        let startFake2 = Coordinate(latitude: -17.395167, longitude: -66.176963)
//        var routePointsFake2 = [Coordinate]()
//        routePointsFake2.append(Coordinate(latitude: -17.395167, longitude: -66.176963))
//        routePointsFake2.append(Coordinate(latitude: -17.395274, longitude: -66.176126))
//        routePointsFake2.append(Coordinate(latitude: -17.395371, longitude: -66.175389))
//        routePointsFake2.append(Coordinate(latitude: -17.395411, longitude: -66.175333))
//        routePointsFake2.append(Coordinate(latitude: -17.395475, longitude: -66.17532))
//        routePointsFake2.append(Coordinate(latitude: -17.395734, longitude: -66.175376))
//        routePointsFake2.append(Coordinate(latitude: -17.396059, longitude: -66.175451))
//        routePointsFake2.append(Coordinate(latitude: -17.396532, longitude: -66.175538))
//        routePointsFake2.append(Coordinate(latitude: -17.398454, longitude: -66.17588))
//        routePointsFake2.append(Coordinate(latitude: -17.400233, longitude: -66.176186))
//        routePointsFake2.append(Coordinate(latitude: -17.400479, longitude: -66.176159))
//        routePointsFake2.append(Coordinate(latitude: -17.400772, longitude: -66.17629))
//        routePointsFake2.append(Coordinate(latitude: -17.400631, longitude: -66.176977))
//        routePointsFake2.append(Coordinate(latitude: -17.400851, longitude: -66.177095))
//        routePointsFake2.append(Coordinate(latitude: -17.400964, longitude: -66.177234))
//        routePointsFake2.append(Coordinate(latitude: -17.400969, longitude: -66.177433))
//        routePointsFake2.append(Coordinate(latitude: -17.400923, longitude: -66.177607))
//        var routeStopsFake2 = [Coordinate]()
//        routeStopsFake2.append(Coordinate(latitude: -17.396059, longitude: -66.175451))
//        let endFake2 = Coordinate(latitude: -17.400923, longitude: -66.177607)
//        let lineRoute2 = LineRoute(
//            name: "Ruta de vuelta",
//            id: "12",
//            idLine: "fds",
//            line: "Line E",
//            routePoints: routePointsFake2,
//            start: startFake2,
//            stops: routeStopsFake2,
//            end: endFake2,
//            averageVelocity: 9.4
//        )
//        self.routePath.transports.append(lineRoute2)
    }
    private func drawRoute(lineRoute: LineRoute) {
        let path = GMSMutablePath()
        for route in lineRoute.routePoints {
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
    private func drawStopsMarkers(linePath: LinePath) {
        for stop in linePath.stops {
            let marker = GMSMarker()
            marker.icon = UIImage(named: "route-stop")
            marker.position = stop.toCLLocationCoordinate2D()
            marker.map = mapView
        }
    }
    private func drawInitialMarkers(linePath: LinePath) {
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
}

extension RouteDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        routePath.transports.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LinePathTableViewCell.linePathCellIdentifier, for: indexPath)
            as? LinePathTableViewCell else { return UITableViewCell() }
        cell.setData(line: routePath.transports[indexPath.row])
        return cell
    }
}

extension GMSMapView {
    func drawPolyline(_ path: GMSMutablePath) -> GMSPolyline? {
      let polyline = GMSPolyline(path: path)
      polyline.strokeWidth = 3.0
      polyline.geodesic = true
      let styles: [GMSStrokeStyle] = [.solidColor(.black), .solidColor(.clear)]
      let scale = 1.0 / projection.points(forMeters: 1.0, at: camera.target)
      let dashLength = NSNumber(value: 3.5 * Float(scale))
      let gapLength = NSNumber(value: 3.0 * Float(scale))
      polyline.spans = GMSStyleSpans(path, styles, [dashLength, gapLength], .rhumb)
      polyline.map = self
      return polyline
   }
}
