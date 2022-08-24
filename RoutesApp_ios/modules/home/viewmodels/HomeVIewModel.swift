//
//  HomeVIewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 10/8/22.
//

import Foundation
import CoreLocation

class HomeViewModel {
    var authManager: AuthProtocol = FirebaseAuthManager.shared
    var currentPosition: CLLocationCoordinate2D?
    func logout() {
        authManager.logout()
    }
}
