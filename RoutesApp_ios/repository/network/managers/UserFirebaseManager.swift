//
//  UserFirebaseManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 8/8/22.
//

import Foundation
import FirebaseFirestore
typealias UserManResult = User

protocol UserManProtocol {
    func registerUser(name: String, email: String, uid: String, typeLogin: UserTypeLogin, completion: @escaping ((Result<UserFirebase, Error>) -> Void))
    func getUsers(completion: @escaping(Result<[UserFirebase], Error>) -> Void)
    func toogleUserRole(user: UserFirebase, completion: @escaping(Result<Bool, Error>) -> Void)
}

enum UserType: Int {
    case NORMAL = 0
    case ADMIN = 1
}

enum UserTypeLogin: Int {
    case NORMAL = 1
    case FACEBOOK = 2
    case GOOGLE = 3
}

class UserFirebaseManager: UserManProtocol {
    let firebaseManager = FirebaseFirestoreManager.shared
    static let shared = UserFirebaseManager()
    func registerUser(name: String, email: String, uid: String, typeLogin: UserTypeLogin, completion: @escaping ((Result<UserFirebase, Error>) -> Void)) {
        let newUser = UserFirebase(id: uid,
                                   name: name,
                                   email: email,
                                   phoneNumber: "",
                                   type: 0,
                                   typeLogin: typeLogin.rawValue,
                                   updatedAt: Float(NSDate().timeIntervalSince1970),
                                   createdAt: Float(NSDate().timeIntervalSince1970))
        self.firebaseManager.addDocument(document: newUser, collection: .Users, completion: completion)
    }

    func getUsers(completion: @escaping(Result<[UserFirebase], Error>) -> Void) {
        self.firebaseManager.getDocuments(type: UserFirebase.self, forCollection: .Users, completion: completion)
    }

    func toogleUserRole(user: UserFirebase, completion: @escaping(Result<Bool, Error>) -> Void) {
        var finalUserInfo = user
        finalUserInfo.type = abs(user.type - 1)
        finalUserInfo.updatedAt = Float(NSDate().timeIntervalSince1970)
        firebaseManager.updateDocument(document: finalUserInfo, forCollection: .Users) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
