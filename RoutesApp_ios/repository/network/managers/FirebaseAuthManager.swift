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
import FacebookLogin
import FBSDKLoginKit

protocol AuthProtocol {
    func signupUser(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void)
    func signInWithGoogle(target: UIViewController, completion: @escaping (Result<(credential: NSObject, email: String), Error>) -> Void)
    func signInWithFacebook(target: UIViewController, completion: @escaping (Result<(credential: NSObject, email: String), Error>) -> Void)
    func firebaseSocialMediaSignIn(with credential: NSObject, completion: @escaping (Result<NSObject?, Error>) -> Void)
    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void)
    func logout() -> Bool
    func userIsLoggedIn() -> Bool
}

enum AuthErrors: String, Error {
    case ERROR_WEAK_PASSWORD
    case ERROR_INVALID_EMAIL
    case ERROR_EMAIL_ALREADY_IN_USE
    case ERROR_GOOGLE_SIGN_IN_TOKEN
    case ERROR_FACEBOOK_SIGN_IN_TOKEN
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

    func signInWithGoogle(target: UIViewController, completion: @escaping (Result<(credential: NSObject, email: String), Error>) -> Void) {
        GIDSignIn.sharedInstance.signOut()
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: target) { (user, error) in
            if let error = error { return completion(.failure(error)) }
            guard let authentication = user?.authentication,
                let idToken = authentication.idToken,
                let user = user, let profile = user.profile else { return completion(.failure(AuthErrors.ERROR_GOOGLE_SIGN_IN_TOKEN)) }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
            completion(.success((credential, profile.email)))
        }
    }

    func firebaseSocialMediaSignIn(with credential: NSObject, completion: @escaping (Result<NSObject?, Error>) -> Void) {
        try? Auth.auth().signOut()
        guard let credential = credential as? AuthCredential else {
            completion(.failure(AuthErrors.ERROR_GOOGLE_SIGN_IN_TOKEN))
            return
        }
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
              let authError = error as NSError
                return completion(.failure(authError))
            }
            completion(.success(authResult))
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

    func signInWithFacebook(target: UIViewController, completion: @escaping (Result<(credential: NSObject, email: String), Error>) -> Void) {
        try? Auth.auth().signOut()
        let fbLogin = LoginManager()
        if let currentToken = AccessToken.current {
            fbLogin.logOut()
        }
        fbLogin.logIn(permissions: ["public_profile", "email"],
                      viewController: target) { result in
            switch result {
            case .success(granted: _, declined: _, token: let token):
                let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters:
                                                            ["fields": "email,name"], tokenString: token.tokenString, version: nil, httpMethod: .get)
                request.start {(_, result, error)  in
                    if let error = error { return completion(.failure(error)) }
                    guard let userDict = result as? [String: Any],
                          let email = userDict["email"] as? String else { return completion(.failure(AuthErrors.ERROR_FACEBOOK_SIGN_IN_TOKEN))}
                    let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                    completion(.success((credential, email)))
                }
            case .cancelled, .failed:
                completion(.failure(AuthErrors.ERROR_FACEBOOK_SIGN_IN_TOKEN))
                fbLogin.logOut()
            }
        }
    }

}
