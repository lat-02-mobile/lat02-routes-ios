//
//  LoginViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation
import UIKit

class LoginViewModel {
    var authManager: AuthProtocol = FirebaseAuthManager.shared
    var userManager: UserManProtocol = UserFirebaseManager.shared
    var onFinish: (() -> Void)?
    var onError: ((_ error: String) -> Void)?

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
