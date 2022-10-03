//
//  CitySplashViewController.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import UIKit

class CitySplashViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    var timer = Timer()
    var cityId = ""
    var city = ""
    var country = ""
    var cityLat = ""
    var cityLng = ""
    let viewmodel = CitySplashViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCityName()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        initTimer()
    }

    func setUpCityName() {
        guard !city.isEmpty, !cityId.isEmpty, !cityLat.isEmpty, !cityLng.isEmpty else { return }
        let desc = (String.localizeString(localizedString: "welcome-message"))
        let text = "\(desc) \(city)"
        cityNameLabel.text = text

        let lat = Double(cityLat)
        let lng = Double(cityLng)
        ConstantVariables.defaults.set(city, forKey: ConstantVariables.defCitySelected)
        ConstantVariables.defaults.set(lat, forKey: ConstantVariables.defCityLat)
        ConstantVariables.defaults.set(lng, forKey: ConstantVariables.defCityLong)
        ConstantVariables.defaults.set(cityId, forKey: ConstantVariables.defCityId)
    }

    func initTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateMaps), userInfo: nil, repeats: true)
    }

    @objc
    private func updateMaps() {
        timer.invalidate()
        SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: viewmodel.authManager.userIsLoggedIn())
    }
}
