//
//  SignupViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import UIKit
import SVProgressHUD

class SignupViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    let viewmodel = SignupViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    func initViewModel() {
        viewmodel.onFinish = { [weak self] in
            SVProgressHUD.dismiss()
            self?.errorLabel.isHidden = true
            let phoneAuthenticationScreen = PhoneAuthenticationViewController()
            self?.show(phoneAuthenticationScreen, sender: nil)
        }
        viewmodel.onError = { [weak self] error in
            SVProgressHUD.dismiss()
            self?.errorLabel.isHidden = false
            self?.errorLabel.text = error
        }
    }

    @IBAction func signup(_ sender: Any) {
        SVProgressHUD.show()
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let name = nameTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return }
        viewmodel.signupUser(email: email, name: name, password: password, confirmPassword: confirmPassword)
    }

    @IBAction func googleSignin(_ sender: Any) {
        SVProgressHUD.show()
        viewmodel.googleSignin(self)
    }

    @IBAction func login(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func facebookSignin(_ sender: Any) {
        SVProgressHUD.show()
        viewmodel.facebookSignIn(self)
    }
}
