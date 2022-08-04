//
//  SignupViewController.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import UIKit
import FirebaseAuth

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
            self?.errorLabel.isHidden = true
            // MARK: Here probably goes the redirection for the phone validation screen and after that the following line
            self?.navigationController?.popViewController(animated: true)
        }
        viewmodel.onError = { [weak self] error in
            self?.errorLabel.isHidden = false
            self?.errorLabel.text = error
        }
    }

    @IBAction func signup(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let name = nameTextField.text,
              let confirmPassword = confirmPasswordTextField.text else { return }
        viewmodel.signupUser(email: email, name: name, password: password, confirmPassword: confirmPassword)
    }
}
