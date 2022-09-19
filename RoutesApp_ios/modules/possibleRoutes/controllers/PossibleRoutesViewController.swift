//
//  PossibleRoutesViewController.swift
//  RoutesApp_ios
//
//  Created by user on 17/9/22.
//

import UIKit
import GoogleMaps

class PossibleRoutesViewController: UIViewController {

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var routesLabel: UILabel!
    var zoom: Float = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupMap()
    }

    func setupMap() {
        if let styleURL = Bundle.main.url(forResource: "silver-style", withExtension: "json") {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
            mapView.settings.zoomGestures = true
        }
        let list = [
            Coordinate(latitude: -16.520939322501413, longitude: -68.12557074070023),
            Coordinate(latitude: -16.521062847351256, longitude: -68.12514516472181),
            Coordinate(latitude: -16.52130602845841, longitude: -68.12417648825397),
            Coordinate(latitude: -16.521670987319112, longitude: -68.12320625310048),
            Coordinate(latitude: -16.52197231180913, longitude: -68.12260107624422),
            Coordinate(latitude: -16.522451435494332, longitude: -68.12218135682076),
            Coordinate(latitude: -16.523261825566387, longitude: -68.12214426533951),
            Coordinate(latitude: -16.523703514803486, longitude: -68.1221403609752),
            Coordinate(latitude: -16.523780248849537, longitude: -68.12235510114752),
            Coordinate(latitude: -16.524002964559173, longitude: -68.12266159393164),
            Coordinate(latitude: -16.524285569842718, longitude: -68.12298370418992)
        ]
        GoogleMapsHelper.shared.drawDotPolyline(map: mapView, list: list)
        GoogleMapsHelper.shared.fitAllMarkers(map: mapView, list: list)
        GoogleMapsHelper.shared.addCustomMarker(map: mapView, position: list[0], icon: UIImage(named: ConstantVariables.originMarkerName))
        GoogleMapsHelper.shared.addCustomMarker(map: mapView, position: list[5], icon: UIImage(named: ConstantVariables.stopMarkerName))
        GoogleMapsHelper.shared.addCustomMarker(map: mapView, position: list.last!, icon: UIImage(named: ConstantVariables.destinationMarkerName))

    }

    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.animate(to: GMSCameraPosition.camera(withTarget: toLocation!, zoom: zoom))
        }
    }

    func setupViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPossibleRoutesPage))
        headerView.addGestureRecognizer(tap)
    }

    @objc
    func showPossibleRoutesPage() {

        let viewController = BottomSheetViewController()
//        viewController.delegate = self

        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }

        self.present(viewController, animated: true)
    }
}
