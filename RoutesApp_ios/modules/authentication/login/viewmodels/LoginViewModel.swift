//
//  LoginViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewModel {
    var authManager: AuthProtocol = FirebaseAuthManager.shared
    var userManager: UserManProtocol = UserFirebaseManager.shared
    var onFinish: (() -> Void)?
    var onError: ((_ error: String) -> Void)?

    func loginUser(email: String, password: String) {
        authManager.loginUser(email: email, password: password) { result in
            switch result {
            case .success:
                self.getUserByEmail(for: email) { userId in
                    ConstantVariables.defaults.set(userId, forKey: ConstantVariables.defUserLoggedId)
                }
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
                        self.signUpWithFirebase(credential: credential) { authData in
                            guard let authData = authData as? AuthDataResult else {
                                self.onError?(String.localizeString(localizedString: "error-unknown"))
                                return
                            }
                            self.getUserByEmail(for: authData.user.email ?? "") { userId in
                                ConstantVariables.defaults.set(userId, forKey: ConstantVariables.defUserLoggedId)
                            }
                        }
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
                self.getUserByEmail(for: email) { userId in
                    ConstantVariables.defaults.set(userId, forKey: ConstantVariables.defUserLoggedId)
                    self.onFinish?()
                }
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
    private func getUserByEmail(for email: String, completion: @escaping ((_ userId: String) -> Void)) {
        userManager.getUsers { result in
            switch result {
            case .success(let users):
                let foundUser = users.filter {$0.email == email}
                if !foundUser.isEmpty {
                    completion(foundUser.first!.id)
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    // MARK: Facebook
    func facebookSignIn(_ target: UIViewController) {
        authManager.signInWithFacebook(target: target) { (result) in
            switch result {
            case .success((let credential, let email)):
                self.getUser(email: email) { user in
                    if let user = user, user.typeLogin != UserTypeLogin.FACEBOOK.rawValue {
                        self.onError?(String.localizeString(localizedString: "error-signup-email-exist"))
                        return
                    }
                    if let user = user, user.typeLogin == UserTypeLogin.FACEBOOK.rawValue {
                        self.signUpWithFirebase(credential: credential) { authData in
                            guard let authData = authData as? AuthDataResult else {
                                self.onError?(String.localizeString(localizedString: "error-unknown"))
                                return
                            }
                            self.getUserByEmail(for: authData.user.email ?? "") { userId in
                                ConstantVariables.defaults.set(userId, forKey: ConstantVariables.defUserLoggedId)
                            }
                        }
                        return
                    }
                    self.signUpWithFirebase(credential: credential) { authData in
                        guard let authData = authData as? AuthDataResult else {
                            self.onError?(String.localizeString(localizedString: "error-unknown"))
                            return
                        }
                        self.createUser(with: UserTypeLogin.FACEBOOK, name: authData.user.displayName ?? "N/N", email: authData.user.email ?? "")
                    }
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
