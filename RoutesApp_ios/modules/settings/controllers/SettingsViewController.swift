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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpCityName()
    }

    @IBAction func changeUbication(_ sender: Any) {
        let vc = CityPickerViewController()
        vc.isSettingsController = true
        show(vc, sender: nil)
    }

    func setUpCityName() {
        guard let citySelected = ConstantVariables.defaults.string(forKey: ConstantVariables.defCitySelected) else { return }
        ubicationLabel.text = citySelected
    }

}
