//
//  UserFirebaseManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 8/8/22.
//

import Foundation

typealias UserManResult = User

protocol UserManProtocol {
    func registerUser(name: String, email: String, uid: String, typeLogin: UserTypeLogin, completion: @escaping ((Result<User, Error>) -> Void))
    func getUsers(completion: @escaping(Result<[User], Error>) -> Void)
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
                           updatedAt: Date(),
                           createdAt: Date())
        self.firebaseManager.addDocument(document: newUser, collection: .Users, completion: completion)
    }
    func getUsers(completion: @escaping(Result<[User], Error>) -> Void) {
        self.firebaseManager.getDocuments(type: User.self, forCollection: .Users, completion: completion)
    }
}
