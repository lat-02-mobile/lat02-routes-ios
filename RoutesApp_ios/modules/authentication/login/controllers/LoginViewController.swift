//
//  LoginViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToRegister(_ sender: Any) {
        let vc = SignupViewController()
        show(vc, sender: nil)
    }
}
