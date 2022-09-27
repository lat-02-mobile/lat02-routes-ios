//
//  SettingsViewModel.swift
//  RoutesApp_ios
//
//  Created by admin on 8/26/22.
//

import Foundation

class SettingsViewModel {
    var authManager: AuthProtocol = FirebaseAuthManager.shared
    func logout() -> Bool {
        return authManager.logout()
    }
}
