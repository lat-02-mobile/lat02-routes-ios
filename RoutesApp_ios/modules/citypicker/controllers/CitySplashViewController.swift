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
    var timer2 = Timer()
    var cityId = ""
    var city = ""
    var country = ""
    var cityLat = ""
    var cityLng = ""
    let viewmodel = CitySplashViewModel.shared
    private var fetchDataRunning = true
    private var timerCounter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCityName()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        initViewModel()
    }

    private func initViewModel() {
        initTimer()
        viewmodel.retrieveAllDataFromFirebaseAndSave()
        viewmodel.onFinish = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.fetchDataRunning = false
        }
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
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(callSetUpRootController), userInfo: nil, repeats: true)
    }

    @objc private func callSetUpRootController() {
        timerCounter += 1
        if timerCounter >= 3 && !fetchDataRunning {
            timer.invalidate()
            SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: viewmodel.authManager.userIsLoggedIn())
        }
    }
}
