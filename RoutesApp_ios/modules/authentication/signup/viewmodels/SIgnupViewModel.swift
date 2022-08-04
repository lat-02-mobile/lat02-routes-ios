//
//  SIgnupViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import Foundation

class SignupViewModel {
    let authManager = FirebaseAuthManager.shared
    let firebaseManager = FirebaseFirestoreManager.shared
    var onFinish: (() -> Void)?
    var onError: ((_ error: String) -> Void)?
    func signupUser(email: String, name: String, password: String, confirmPassword: String) {
        guard password == confirmPassword else {
            onError?("The passwords do not match")
            return
        }
        authManager.signupUser(email: email, password: password) { [self] result in
            switch result {
            case .success(let authResult):
                print(authResult)
                let newUserId = self.firebaseManager.getDocID(forCollection: .Users)
                let newUser = User(id: newUserId, name: name, email: email)
                self.firebaseManager.addDocument(document: newUser,
                                                 collection: .Users) { result in
                    switch result {
                    case .success(let user):
                        print(user)
                        self.onFinish?()
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.onError?(error.localizedDescription)
            }
        }
    }
}
