//
//  UserListViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 2/11/22.
//

import Foundation

class UserListViewModel: ViewModel {
    var userManager: UserManProtocol = UserFirebaseManager()
    var userList = [User]()
    var originalUserList = [User]()

    func getUsers() {
        userManager.getUsers { result in
            switch result {
            case .success(let users):
                self.userList = users
                self.originalUserList = users
                self.onFinish?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func toggleUserRole(for targetUser: User) {
        userManager.toogleUserRole(user: targetUser) { result in
            switch result {
            case .success:
                self.getUsers()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func applyFilters(query: String) {
        filterUsersBy(query: query)
        onFinish?()
    }

    private func filterUsersBy(query: String) {
        if query.isEmpty {
            userList = originalUserList
        } else {
            let normalizedQuery = query.uppercased()
            userList = originalUserList.filter({ $0.name.uppercased().contains(normalizedQuery) || $0.email.uppercased().contains(normalizedQuery)})
        }
    }
}
