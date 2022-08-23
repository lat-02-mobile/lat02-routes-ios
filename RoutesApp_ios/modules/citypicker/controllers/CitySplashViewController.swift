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
    var city: String = ""
    let viewmodel = HomeViewModel()

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
        guard !city.isEmpty else { return }
        let desc = (String.localizeString(localizedString: "welcome-message"))
        let text = "\(desc) \(city)"
        cityNameLabel.text = text

        ConstantVariables.defaults.set(city, forKey: ConstantVariables.defCitySelected)
    }

    func initTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateMaps), userInfo: nil, repeats: true)
    }

    @objc func updateMaps() {
        timer.invalidate()
        SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: viewmodel.authManager.userIsLoggedIn())
    }
}
