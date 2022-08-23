//
//  HomeViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 2/8/22.
//

import UIKit

class HomeViewController: UIViewController {
    let viewmodel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        verifyFirstTimeApp()
    }

    func verifyFirstTimeApp() {
        let app = ConstantVariables.defaults.bool(forKey: ConstantVariables.deflaunchApp)
        let citySelected = ConstantVariables.defaults.string(forKey: ConstantVariables.defCitySelected)

        guard app, (citySelected == nil) else { return }
        let vc = CityPickerViewController()
        vc.isSettingsController = false
        show(vc, sender: nil)
    }

    @IBAction func logout(_ sender: Any) {
        viewmodel.logout()
        SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: viewmodel.authManager.userIsLoggedIn())
    }
}
