//
//  FirebaseAuthManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 3/8/22.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

protocol AuthProtocol {
    func signupUser(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void)
    func signInWithGoogle(target: UIViewController, completion: @escaping (Result<(credential: AuthCredential, email: String), Error>) -> Void)
    func firebaseSocialMediaSignIn(with credential: AuthCredential, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
}

enum AuthErrors: String, Error {
    case ERROR_WEAK_PASSWORD
    case ERROR_INVALID_EMAIL
    case ERROR_EMAIL_ALREADY_IN_USE
    case ERROR_GOOGLE_SIGN_IN_TOKEN
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

    func signInWithGoogle(target: UIViewController, completion: @escaping (Result<(credential: AuthCredential, email: String), Error>) -> Void) {
        GIDSignIn.sharedInstance.signOut()
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: target) { (user, error) in
            if error != nil { return completion(.failure(error!)) }
            guard let authentication = user?.authentication,
                let idToken = authentication.idToken,
                let user = user, let profile = user.profile else { return completion(.failure(AuthErrors.ERROR_GOOGLE_SIGN_IN_TOKEN)) }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
            completion(.success((credential, profile.email)))
        }
    }

    func firebaseSocialMediaSignIn(with credential: AuthCredential, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        try? Auth.auth().signOut()
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
              let authError = error as NSError
                return completion(.failure(authError))
            }
            completion(.success(authResult!))
        }
    }
}
