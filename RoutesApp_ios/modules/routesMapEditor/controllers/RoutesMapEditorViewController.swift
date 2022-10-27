//
//  RoutesMapEditorViewController.swift
//  RoutesApp_ios
//
//  Created by user on 25/10/22.
//

import UIKit
import GoogleMaps

class RoutesMapEditorViewController: UIViewController {

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var sortButton: FabButton!
    @IBOutlet var stopsButton: FabButton!
    @IBOutlet var addRemoveButton: FabButton!

    var viewModel = RoutesMapEditorViewModel()

    init(currentLinePath: LineRouteEntity) {
        viewModel.setLinePath(linePath: currentLinePath)
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupMap()
        fitRoute()
        drawMarkers()
    }

    func setupMap() {
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        if let styleURL = Bundle.main.url(forResource: ConstantVariables.mapStyle, withExtension: ConstantVariables.mapStyleExt) {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
            mapView.settings.zoomGestures = true
        }
        mapView.delegate = self
        sortButton.isHidden = true
    }

    private func fitRoute() {
        let linePath = viewModel.getLinePath()
        GoogleMapsHelper.shared.fitAllMarkers(map: mapView, list: linePath.routePoints)
    }

    private func drawMarkers() {
        let pointsWithType = viewModel.getPointsRoutesWithType()
        for (index, point) in pointsWithType.enumerated() {
            var color = ColorConstants.routePointColor
            if point.type == CoordinateType.STOP {
                color = ColorConstants.stopPointColor
            }
            let stopMarkerIcon = ImageHelper.shared.imageWith(name: String(index + 1), backgroundColor: color )
            GoogleMapsHelper.shared.addCustomMarker(map: mapView, position: point.point, icon: stopMarkerIcon)
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    private func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        guard let location = toLocation else { return }
        mapView.animate(to: GMSCameraPosition.camera(withTarget: location, zoom: 18))
    }

    private func isStopPoint(coordinate: CLLocationCoordinate2D) -> Bool {
        let linePath = viewModel.getLinePath()
        return linePath.stops.contains(where: { $0.latitude == coordinate.latitude && $0.longitude == coordinate.longitude })
    }
}

extension RoutesMapEditorViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        cameraMoveToLocation(toLocation: marker.position)
        sortButton.isHidden = false
        let stopButtonImageName = isStopPoint(coordinate: marker.position) ? "remove-stop" : "bus-stop"
        stopsButton.setImage(UIImage(named: stopButtonImageName), for: .normal)
        addRemoveButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        return true
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            sortButton.isHidden = true
            stopsButton.setImage(UIImage(named: "bus-stop"), for: .normal)
            addRemoveButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
}
