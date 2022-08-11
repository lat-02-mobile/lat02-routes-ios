//
//  FirebaseAuthManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 3/8/22.
//

import Foundation
import FirebaseAuth

protocol AuthProtocol {
    func signupUser(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void)
    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void)
    func logout() -> Bool
    func userIsLoggedIn() -> Bool
}

enum AuthErrors: String {
    case ERROR_WEAK_PASSWORD
    case ERROR_INVALID_EMAIL
    case ERROR_EMAIL_ALREADY_IN_USE
}

class FirebaseAuthManager: AuthProtocol {
    static let shared = FirebaseAuthManager()
    func signupUser(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    func logout() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    func userIsLoggedIn() -> Bool {
        Auth.auth().currentUser != nil
    }
}
