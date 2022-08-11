//
//  LoginViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ViewModel {
    var authManager: AuthProtocol = FirebaseAuthManager.shared
    func loginUser(email: String, password: String) {
        authManager.loginUser(email: email, password: password) { result in
            switch result {
            case .success:
                self.onFinish?()
            case .failure(let error):
                switch AuthErrorCode(rawValue: error._code) {
                case .userNotFound:
                    self.onError?(String.localizeString(localizedString: "error-login-email-not-found"))
                case .wrongPassword:
                    self.onError?(String.localizeString(localizedString: "error-login-password-wrong"))
                default:
                    self.onError?(String.localizeString(localizedString: "error-unknown"))
                }
            }
        }
    }
}
