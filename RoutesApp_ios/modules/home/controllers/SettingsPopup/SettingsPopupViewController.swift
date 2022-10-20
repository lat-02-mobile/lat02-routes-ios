//
//  SettingsPopupViewController.swift
//  RoutesApp_ios
//
//  Created by admin on 10/19/22.
//

import UIKit

class SettingsPopupViewController: UIViewController {

    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var tourpointsSwitch: UISwitch!
    @IBOutlet weak var tourpointsLabel: UILabel!

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
            settingsView.backgroundColor = .red
        } else {
            settingsView.backgroundColor = .blue
        }
    }

}
