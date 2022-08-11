//
//  LoginViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    let viewmodel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    func initViewModel() {
        viewmodel.onFinish = { [weak self] in
            guard let strongSelf = self else {return}
            SVProgressHUD.dismiss()
            strongSelf.errorLabel.isHidden = true
            SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: strongSelf.viewmodel.authManager.userIsLoggedIn())
        }
        viewmodel.onError = { [weak self] error in
            guard let strongSelf = self else {return}
            SVProgressHUD.dismiss()
            strongSelf.errorLabel.isHidden = false
            strongSelf.errorLabel.text = error
        }
    }
    @IBAction func login(_ sender: Any) {
        SVProgressHUD.show()
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        viewmodel.loginUser(email: email, password: password)
    }
    @IBAction func goToRegister(_ sender: Any) {
        let vc = SignupViewController()
        show(vc, sender: nil)
    }
}
