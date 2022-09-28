//
//  SettingsViewController.swift
//  RoutesApp_ios
//
//  Created by admin on 8/22/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var ubicationButton: UIButton!
    @IBOutlet weak var ubicationLabel: UILabel!
    let viewmodel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        setUpCityName()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func changeUbication(_ sender: Any) {
        let vc = CityPickerViewController()
        vc.isSettingsController = true
        show(vc, sender: nil)
    }

    func setUpCityName() {
        guard let citySelected = ConstantVariables.defaults.string(forKey: ConstantVariables.defCitySelected) else { return }
        ubicationLabel.textColor = UIColor(named: ConstantVariables.primaryColor)
        ubicationLabel.text = citySelected
    }

    @IBAction func signOut(_ sender: Any) {
        let result = viewmodel.logout()
        guard result else { return }

        ConstantVariables.defaults.set("", forKey: ConstantVariables.defCitySelected)
        ConstantVariables.defaults.set(0, forKey: ConstantVariables.defCityLat)
        ConstantVariables.defaults.set(0, forKey: ConstantVariables.defCityLong)
        CoreDataManager.shared.deleteAll()
        ConstantVariables.defaults.removeObject(forKey: ConstantVariables.defUserLoggedId)
        SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: viewmodel.authManager.userIsLoggedIn())
    }
}
