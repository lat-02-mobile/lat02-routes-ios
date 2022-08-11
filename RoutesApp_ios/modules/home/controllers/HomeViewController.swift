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

    }
    @IBAction func logout(_ sender: Any) {
        viewmodel.logout()
        SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: viewmodel.authManager.userIsLoggedIn())
    }
}
