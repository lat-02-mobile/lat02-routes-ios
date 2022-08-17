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
    func signInWithGoogle(target: UIViewController, completion: @escaping (Result<(credential: NSObject, email: String), Error>) -> Void)
    func firebaseSocialMediaSignIn(with credential: NSObject, completion: @escaping (Result<NSObject?, Error>) -> Void)
    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void)
    func sendPhoneNumberCode(phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void)
    func verifyPhoneNumber(currentVerificationId: String, code: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void)
    func logout() -> Bool
    func userIsLoggedIn() -> Bool
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
    func sendPhoneNumberCode(phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        let localLanguage = NSLocale.current.languageCode
        Auth.auth().languageCode = localLanguage
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                completion(.failure(error))
            } else if let verificationID = verificationID {
                completion(.success(verificationID))
            }
        }
    }
    func verifyPhoneNumber(currentVerificationId: String, code: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        let user = Auth.auth().currentUser
        let credential = PhoneAuthProvider.provider().credential(
             withVerificationID: currentVerificationId,
             verificationCode: code
         )
        user?.link(with: credential) { authResult, error in
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
