//
//  SIgnupViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation
import FirebaseAuth
import UIKit

class SignupViewModel {
    var authManager: AuthProtocol = FirebaseAuthManager.shared
    var userManager: UserManProtocol = UserFirebaseManager.shared
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

    // MARK: Google
    func googleSignin(_ target: UIViewController) {
        authManager.signInWithGoogle(target: target) { (result) in
            switch result {
            case .success((let credential, let email)):
                self.canUserLoginBy(UserTypeLogin.GOOGLE, email: email) { canLogin in
                    guard canLogin else {
                        self.onError?(String.localizeString(localizedString: "error-signup-email-exist"))
                        return
                    }
                    self.authManager.firebaseSocialMediaSignIn(with: credential) {_ in
                        self.onFinish?()
                    }
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    private func canUserLoginBy(_ typeLogin: UserTypeLogin, email: String, completion: @escaping ((_ isRegistered: Bool) -> Void)) {
        userManager.getUsers { result in
            switch result {
            case .success(let users):
                let email = users.filter {$0.email == email && $0.typeLogin == typeLogin.rawValue}
                completion(email.isEmpty)
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
