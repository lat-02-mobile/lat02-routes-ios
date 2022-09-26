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
    var viewModel = PossibleRoutesViewModel()

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
        viewModel.map = mapView
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
        let viewController = BottomSheetViewController(viewModel: viewModel)
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        self.present(viewController, animated: true)
    }
}
