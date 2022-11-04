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
    @IBOutlet weak var adminButton: UIButton!
    let viewmodel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        setUpCityName()
        let type = ConstantVariables.defaults.object(forKey: ConstantVariables.defUserType)
        guard let admin = type as? Int else { return }
        if admin == 1 {
            adminButton.isHidden = false
        }
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

    @IBAction func adminPanel(_ sender: Any) {
        let vc = AdminViewController()
        vc.isSettingsController = true
        show(vc, sender: nil)
    }

    @IBAction func signOut(_ sender: Any) {
        let result = viewmodel.logout()
        guard result else { return }

        ConstantVariables.defaults.set("", forKey: ConstantVariables.defCitySelected)
        ConstantVariables.defaults.set("", forKey: ConstantVariables.defUserType)
        ConstantVariables.defaults.set(0, forKey: ConstantVariables.defCityLat)
        ConstantVariables.defaults.set(0, forKey: ConstantVariables.defCityLong)
        CoreDataManager.shared.deleteAll()
        ConstantVariables.defaults.removeObject(forKey: ConstantVariables.defUserLoggedId)
        SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: viewmodel.authManager.userIsLoggedIn())
    }
}
