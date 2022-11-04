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
    func registerUser(name: String, email: String, uid: String, typeLogin: UserTypeLogin, completion: @escaping ((Result<User, Error>) -> Void))
    func getUsers(completion: @escaping(Result<[User], Error>) -> Void)
    func toogleUserRole(user: User, completion: @escaping(Result<Bool, Error>) -> Void)
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
    func registerUser(name: String, email: String, uid: String, typeLogin: UserTypeLogin, completion: @escaping ((Result<User, Error>) -> Void)) {
        let newUser = User(id: uid,
                                   name: name,
                                   email: email,
                                   phoneNumber: "",
                                   type: 0,
                                   typeLogin: typeLogin.rawValue,
                                   updateAt: Timestamp(),
                                   createAt: Timestamp())
        self.firebaseManager.addDocument(document: newUser, collection: .Users, completion: completion)
    }

    func getUsers(completion: @escaping(Result<[User], Error>) -> Void) {
        self.firebaseManager.getDocuments(type: User.self, forCollection: .Users, completion: completion)
    }

    func toogleUserRole(user: User, completion: @escaping(Result<Bool, Error>) -> Void) {
        var finalUserInfo = user
        finalUserInfo.type = abs(user.type - 1)
        finalUserInfo.updateAt = Timestamp()
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
