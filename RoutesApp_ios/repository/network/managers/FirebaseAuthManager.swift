//
//  FirebaseAuthManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 3/8/22.
//

import Foundation
import FirebaseAuth

enum AuthErrors: String {
    case ERROR_WEAK_PASSWORD
    case ERROR_INVALID_EMAIL
    case ERROR_EMAIL_ALREADY_IN_USE
}

class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    func signupUser(email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
//            print(authResult)
            guard let error = error else {return}
            print(error.localizedDescription)
        }
    }
    func login(email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, _ in
//          guard let strongSelf = self else { return }
          // ...
        }
    }
}
