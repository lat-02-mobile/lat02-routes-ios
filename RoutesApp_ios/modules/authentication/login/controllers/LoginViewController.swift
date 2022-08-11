//
//  LoginViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    let viewmodel = SignupViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goToRegister(_ sender: Any) {
        let vc = SignupViewController()
        show(vc, sender: nil)
    }

    @IBAction func googleSignin(_ sender: Any) {
        viewmodel.googleSignin(self)
    }
}
