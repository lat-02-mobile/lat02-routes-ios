//
//  CitySplashViewModel.swift
//  RoutesApp_ios
//
//  Created by Yawar Valeriano on 10/3/22.
//

import Foundation
import CoreData

class CitySplashViewModel: ViewModel {
    static let shared = CitySplashViewModel()

    let authManager: AuthProtocol = FirebaseAuthManager.shared
    var localDataManager: LocalDataManagerProtocol = LocalDataManager.shared

    func retrieveAllDataFromFirebaseAndSave() {
        localDataManager.retrieveAllDataFromFirebase { result in
            switch result {
            case.success:
                self.onFinish?()
            case.failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
