//
//  SIgnupViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation
import FirebaseAuth

class SignupViewModel {
    let authManager = FirebaseAuthManager.shared
    let userManager = UserFirebaseManager.shared
    var onFinish: (() -> Void)?
    var onError: ((_ error: String) -> Void)?
    func signupUser(email: String, name: String, password: String, confirmPassword: String) {
        guard password == confirmPassword else {
            onError?(String.localizeString(localizedString: "error-signup-passwords"))
            return
        }
        guard name != ""  else {
            onError?(String.localizeString(localizedString: "error-signup-name"))
            return
        }
        self.checkExistingUser(for: email) { [self] isRegistered in
            if isRegistered {
                self.onError?(String.localizeString(localizedString: "error-signup-email-exist"))
            } else {
                authManager.signupUser(email: email, password: password) { result in
                    switch result {
                    case .success(let authResult):
                        print(authResult)
                        self.userManager.registerUser(name: name, email: email, typeLogin: .NORMAL) {
                            self.onFinish?()
                        }
                    case .failure(let error):
                        print(error)
                        switch AuthErrorCode(rawValue: error._code) {
                        case .invalidEmail:
                            self.onError?(String.localizeString(localizedString: "error-signup-email"))
                        case .missingEmail:
                            self.onError?(String.localizeString(localizedString: "error-signup-email-empty"))
                        case .weakPassword:
                            self.onError?(String.localizeString(localizedString: "error-signup-password-weak"))
                        default:
                            self.onError?(String.localizeString(localizedString: "error-unknown"))
                        }
                    }
                }
            }
        }
    }
    private func checkExistingUser(for email: String, completion: @escaping ((_ isRegistered: Bool) -> Void)) {
        userManager.getUsers { result in
            switch result {
            case .success(let users):
                let email = users.filter {$0.email == email}
                completion(!email.isEmpty)
            case .failure(let error):
                print(error)
                self.onError?(error.localizedDescription)
            }
        }
    }
}
