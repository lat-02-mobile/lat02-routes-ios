//
//  UserFirebaseManager.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 8/8/22.
//

import Foundation

enum UserType: Int {
    case NORMAL = 0
    case ADMIN = 1
}

enum UserTypeLogin: Int {
    case NORMAL = 1
    case FACEBOOK = 2
    case GOOGLE = 3
}

class UserFirebaseManager {
    let firebaseManager = FirebaseFirestoreManager.shared
    static let shared = UserFirebaseManager()
    func registerUser(name: String, email: String, typeLogin: UserTypeLogin, completion: @escaping (() -> Void)) {
        let newUserId = self.firebaseManager.getDocID(forCollection: .Users)
        let newUser = User(id: newUserId,
                           name: name,
                           email: email,
                           phoneNumber: "",
                           type: 0,
                           typeLogin: typeLogin.rawValue,
                           updatedAt: Date(),
                           createdAt: Date())
        self.firebaseManager.addDocument(document: newUser,
                                         collection: .Users) { result in
            switch result {
            case .success(let user):
                print(user)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    func getUsers(completion: @escaping(Result<[User], Error>) -> Void) {
        self.firebaseManager.getDocuments(type: User.self, forCollection: .Users, completion: completion)
    }
}
