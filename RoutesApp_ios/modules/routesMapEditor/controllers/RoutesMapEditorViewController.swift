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
    var currentMarker: GMSMarker?
    var markers: [GMSMarker] = []

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

    @IBAction func checkButtonAction(_ sender: Any) {
        var lineRoute = viewModel.getLinePath().toLineRouteInfo()
        guard let start = lineRoute.routePoints.first,
              let end = lineRoute.routePoints.last else { return }
        var stops = lineRoute.stops
        if !stops.contains(start) {
            stops.insert(start, at: 0)
        }
        if !stops.contains(end) {
            stops.append(end)
        }
        lineRoute = LineRouteInfo(name: lineRoute.name, id: lineRoute.id, idLine: lineRoute.idLine, line: lineRoute.line,
                                  routePoints: lineRoute.routePoints, start: start, stops: stops,
                                  end: end, averageVelocity: lineRoute.averageVelocity, color: lineRoute.color,
                                  updateAt: lineRoute.updateAt, createAt: lineRoute.createAt)
        LineRouteFirebaseManager.shared.updateLineRoute(lineRouteInfo: lineRoute) { result in
            switch result {
            case .success:
                Toast.showToast(target: self, message: String.localizeString(localizedString: StringResources.routeEditorToastSuccess))
                self.dismiss(animated: true)
            case .failure:
                Toast.showToast(target: self, message: String.localizeString(localizedString: StringResources.routeEditorToastFailure))
            }
        }
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
        markers.forEach({ marker in
            marker.map = nil
        })
        markers.removeAll()
        let pointsWithType = viewModel.getPointsRoutesWithType()
        for (index, point) in pointsWithType.enumerated() {
            var color = ColorConstants.routePointColor
            if point.type == CoordinateType.STOP {
                color = ColorConstants.stopPointColor
            }
            let stopMarkerIcon = ImageHelper.shared.imageWith(name: String(index + 1), backgroundColor: color )
            let newMarker = GoogleMapsHelper.shared.addCustomMarker(map: mapView, position: point.point, icon: stopMarkerIcon)
            markers.append(newMarker)
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func sortButtonAction(_ sender: Any) {
        let ac = UIAlertController(title: String.localizeString(localizedString: StringResources.rearrangeRouteTitle),
                                   message: nil, preferredStyle: .alert)
        ac.message = String.localizeString(localizedString: StringResources.rearrangeRouteMessage) +
        String(viewModel.getLinePath().routePoints.count + 1)
        ac.addTextField(configurationHandler: { [] (textField: UITextField) in
                    textField.placeholder = String.localizeString(localizedString: StringResources.rearrangeRoutePlaceholder)
                    textField.delegate = self
            textField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        })
        ac.addAction(UIAlertAction(title: String.localizeString(localizedString: StringResources.rearrangeRouteCancel),
                                   style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: String.localizeString(localizedString: StringResources.rearrangeRouteOk),
                                   style: .default, handler: { [] _ in
            let text = ac.textFields?[0].text ?? ""
            guard !text.isEmpty,
                  let newIndex = Int(text),
                  let currentMarker = self.currentMarker,
                  let oldIndex = self.getMarkerIndex(marker: currentMarker) else { return }
            self.viewModel.rearrangeRoutePoint(oldIndex: oldIndex, newIndex: newIndex)
            self.drawMarkers()
        }))
        self.present(ac, animated: true, completion: nil)
    }

    @IBAction func stopButtonAction(_ sender: Any) {
        guard let currentMarker = currentMarker else {
            addRoutePoint()
            return
        }

        guard let index = getMarkerIndex(marker: currentMarker) else { return }
        let position = currentMarker.position
        let coordinate = Coordinate(latitude: position.latitude, longitude: position.longitude)
        let isStop = isStopPoint(coordinate: position)
        if isStop {
            viewModel.removeStop(at: coordinate)
            let isStillStop = isStopPoint(coordinate: position)
            let stopButtonImageName = isStillStop ? "remove-stop" : "bus-stop"
            stopsButton.setImage(UIImage(named: stopButtonImageName), for: .normal)
            addRemoveButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            currentMarker.icon = ImageHelper.shared.imageWith(name: String(index + 1), backgroundColor: isStillStop
                                                              ? ColorConstants.stopPointColor
                                                              : ColorConstants.routePointColor)
            return
        }

        viewModel.convertToStop(coorditate: coordinate)
        currentMarker.icon = ImageHelper.shared.imageWith(name: String(index + 1), backgroundColor: ColorConstants.stopPointColor)
        let stopButtonImageName = isStopPoint(coordinate: currentMarker.position) ? "remove-stop" : "bus-stop"
        stopsButton.setImage(UIImage(named: stopButtonImageName), for: .normal)
    }

    @IBAction func addRemoveButtonAction(_ sender: Any) {
        if let currentMarker = currentMarker {
            let position = currentMarker.position
            let coordinate = Coordinate(latitude: position.latitude, longitude: position.longitude)
            viewModel.removeRoutePoint(at: coordinate)
            viewModel.removeStop(at: coordinate)
            drawMarkers()
            sortButton.isHidden = true
            stopsButton.setImage(UIImage(named: "bus-stop"), for: .normal)
            addRemoveButton.setImage(UIImage(systemName: "plus"), for: .normal)
            self.currentMarker = nil
            return
        }
        addRoutePoint()
    }

    @objc
    func textFieldDidChange(textField: UITextField) {
        guard let text = textField.text,
              let newIndex = Int(text) else { return }
        guard isIntheAllowedRange(newIndex: newIndex) else {
            textField.text = String(text.dropLast())
            return
        }
    }

    private func addRoutePoint() {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let coordinate = Coordinate(latitude: latitude, longitude: longitude)

        viewModel.addCoordinate(coorditate: coordinate)

        let pointsWithType = viewModel.getPointsRoutesWithType()
        let stopMarkerIcon = ImageHelper.shared.imageWith(name: String(pointsWithType.count))

        let newMarker = GoogleMapsHelper.shared.addCustomMarker(map: mapView, position: coordinate, icon: stopMarkerIcon)

        currentMarker = newMarker
        markers.append(newMarker)

        sortButton.isHidden = false
        addRemoveButton.setImage(UIImage(systemName: "xmark"), for: .normal)

        paintCurrentMarker()
    }

    private func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        guard let location = toLocation else { return }
        mapView.animate(to: GMSCameraPosition.camera(withTarget: location, zoom: 18))
    }

    private func isStopPoint(coordinate: CLLocationCoordinate2D) -> Bool {
        let linePath = viewModel.getLinePath()
        return linePath.stops.contains(where: { $0.latitude == coordinate.latitude && $0.longitude == coordinate.longitude })
    }

    private func isIntheAllowedRange(newIndex: Int) -> Bool {
        return newIndex > 0 && newIndex <= viewModel.getLinePath().routePoints.count
    }

    private func getMarkerIndex(marker: GMSMarker) -> Int? {
        let pointsWithType = viewModel.getPointsRoutesWithType()
        let position = marker.position
        let indexOf = pointsWithType.firstIndex(where: {$0.point.latitude == position.latitude &&
            $0.point.longitude == position.longitude})
        return indexOf
    }

    private func paintCurrentMarker() {
        guard let currentMarker = currentMarker else { return }
        let index = markers.firstIndex(of: currentMarker)
        guard let index = index else { return }
        currentMarker.icon = ImageHelper.shared.imageWith(name: String(index + 1), backgroundColor: ColorConstants.selectedPointColor)
    }

    private func unpaintCurrentMarker() {
        guard let currentMarker = currentMarker else { return }
        let index = markers.firstIndex(of: currentMarker)
        guard let index = index else { return }
        let isStopPoint = isStopPoint(coordinate: currentMarker.position)
        currentMarker.icon = ImageHelper.shared.imageWith(name: String(index + 1), backgroundColor: isStopPoint
                                                          ? ColorConstants.stopPointColor
                                                          : ColorConstants.routePointColor)
    }
}

extension RoutesMapEditorViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        unpaintCurrentMarker()

        currentMarker = marker
        cameraMoveToLocation(toLocation: marker.position)
        sortButton.isHidden = false
        let stopButtonImageName = isStopPoint(coordinate: marker.position) ? "remove-stop" : "bus-stop"
        stopsButton.setImage(UIImage(named: stopButtonImageName), for: .normal)
        addRemoveButton.setImage(UIImage(systemName: "xmark"), for: .normal)

        paintCurrentMarker()

        return true
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            sortButton.isHidden = true
            stopsButton.setImage(UIImage(named: "bus-stop"), for: .normal)
            addRemoveButton.setImage(UIImage(systemName: "plus"), for: .normal)

            unpaintCurrentMarker()
            currentMarker = nil
        }
    }
}

extension RoutesMapEditorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
