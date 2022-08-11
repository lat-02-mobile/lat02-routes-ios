//
//  SIgnupViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation
import FirebaseAuth

class SignupViewModel: ViewModel {
    var authManager: AuthProtocol = FirebaseAuthManager.shared
    var userManager: UserManProtocol = UserFirebaseManager.shared
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
                    case .success:
                        self.createUser(name: name, email: email)
                    case .failure(let error):
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
    private func createUser(name: String, email: String) {
        self.userManager.registerUser(name: name, email: email, typeLogin: .NORMAL) { result in
            switch result {
            case .success:
                self.onFinish?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
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
                self.onError?(error.localizedDescription)
            }
        }
    }
}
