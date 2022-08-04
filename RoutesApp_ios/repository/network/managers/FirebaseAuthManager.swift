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
    func signupUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let authResult = authResult else { return }
                completion(.success(authResult))
            }
        }
    }
}
