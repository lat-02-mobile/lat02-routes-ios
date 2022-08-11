//
//  SIgnupViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation
import FirebaseAuth
import UIKit

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

    // MARK: Google
    func googleSignin(_ target: UIViewController) {
        authManager.signInWithGoogle(target: target) { (result) in
            switch result {
            case .success((let credential, let email)):
                self.getUser(email: email) { user in
                    if let user = user, user.typeLogin != UserTypeLogin.GOOGLE.rawValue {
                        self.onError?(String.localizeString(localizedString: "error-signup-email-exist"))
                        return
                    }
                    if let user = user, user.typeLogin == UserTypeLogin.GOOGLE.rawValue {
                        self.signUpWithFirebase(credential: credential) {_ in}
                        return
                    }
                    self.signUpWithFirebase(credential: credential) { authData in
                        guard let authData = authData as? AuthDataResult else {
                            self.onError?(String.localizeString(localizedString: "error-unknown"))
                            return
                        }
                        self.createUser(with: UserTypeLogin.GOOGLE, name: authData.user.displayName ?? "N/N", email: authData.user.email ?? "")
                    }
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    private func getUser(email: String, completion: @escaping ((_ user: User?) -> Void)) {
        userManager.getUsers { result in
            switch result {
            case .success(let users):
                let user = users.filter {$0.email == email} .first
                completion(user)
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    private func signUpWithFirebase(credential: NSObject, completion: @escaping (NSObject?) -> Void) {
        guard let credential = credential as? AuthCredential else { return }
        self.authManager.firebaseSocialMediaSignIn(with: credential) { result in
            switch result {
            case .success(let authData):
                completion(authData)
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
            self.onFinish?()
        }
    }

    private func createUser(with type: UserTypeLogin, name: String, email: String) {
        self.userManager.registerUser(name: name, email: email, typeLogin: type) { result in
            switch result {
            case .success:
                self.onFinish?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
