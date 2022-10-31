//
//  SettingsPopupViewController.swift
//  RoutesApp_ios
//
//  Created by admin on 10/19/22.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import CoreLocation

class SettingsPopupViewController: UIViewController {

    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var tourpointsSwitch: UISwitch!
    @IBOutlet weak var tourpointsLabel: UILabel!

    let viewModel = SettingsPopupViewModel()
    let tourpointsViewModel = TourpointsViewModel()
    let tourpoints = [TourpointEntity]()
    var homeVC = HomeViewController()
    var routeMapVC = RouteMapViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        tourpointsSwitch.isOn = UserDefaults.standard.bool(forKey: ConstantVariables.switchState)
    }

    func setView() {
        settingsView.layer.cornerRadius = 15.0
        tourpointsLabel.text = String.localizeString(localizedString: StringResources.showTourpoints)
    }

    @IBAction func settingsSwitchDidChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: ConstantVariables.switchState)
        if sender.isOn {
            homeVC.showTourpointsMarkers()
            routeMapVC.showTourpointsMarkers()
        } else {
            homeVC.hideTourpointsMarkers()
            routeMapVC.hideTourpointsMarkers()
        }
    }
}
