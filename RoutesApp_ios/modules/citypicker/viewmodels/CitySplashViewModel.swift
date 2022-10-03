//
//  CitySplashViewModel.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//

import Foundation

class CitySplashViewModel: ViewModel {
    static let shared = CitySplashViewModel()
    let authManager: AuthProtocol = FirebaseAuthManager.shared

    func retrieveAllDataFromFirebase() {
        // retrieve data
    }
}
