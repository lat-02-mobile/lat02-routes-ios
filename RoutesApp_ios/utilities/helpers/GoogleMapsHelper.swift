//
//  GoogleMapsHelper.swift
//  RoutesApp_ios
//
//  Created by user on 19/9/22.
//

import Foundation
import GoogleMaps

class GoogleMapsHelper {
    static var shared = GoogleMapsHelper()

    func drawPolyline(map: GMSMapView, list: [Coordinate], hexColor: String = "#004696") {
        let path = GMSMutablePath()
        list.forEach({ path.add($0.toCLLocationCoordinate2D()) })
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = ColorHelper.shared.hexStringToUIColor(hex: hexColor)
        polyline.strokeWidth = 5.0
        polyline.geodesic = true
        polyline.map = map
    }

    func drawDotPolyline(map: GMSMapView, list: [Coordinate], hexColor: String = "#004696") {
        let path = GMSMutablePath()
        list.forEach({ path.add($0.toCLLocationCoordinate2D()) })
        let polyline = GMSPolyline(path: path)
        let styles = [GMSStrokeStyle.solidColor(ColorHelper.shared.hexStringToUIColor(hex: hexColor)), GMSStrokeStyle.solidColor(.clear)]
        let lengths = [NSNumber(5), NSNumber(5)]
        polyline.spans = GMSStyleSpans(polyline.path!, styles, lengths, GMSLengthKind(rawValue: 1)!)
        polyline.strokeWidth = 5.0
        polyline.geodesic = true
        polyline.map = map
    }

    func fitAllMarkers(map: GMSMapView, list: [Coordinate]) {
        var bounds = GMSCoordinateBounds()
        for coor in list {
            bounds = bounds.includingCoordinate(coor.toCLLocationCoordinate2D())
        }
        map.animate(with: GMSCameraUpdate.fit(bounds, withPadding: CGFloat(ConstantVariables.polylinePadding)))
    }

    func addCustomMarker(map: GMSMapView, position: Coordinate, icon: UIImage?) {
        let newMarker = GMSMarker(position: position.toCLLocationCoordinate2D())
        newMarker.icon = icon
        newMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        newMarker.map = map
    }
}
