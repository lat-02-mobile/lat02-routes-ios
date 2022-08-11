//
//  HomeVIewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 10/8/22.
//

import Foundation
class HomeViewModel {
    var authManager: AuthProtocol = FirebaseAuthManager.shared
    func logout() {
        authManager.logout()
    }
}
