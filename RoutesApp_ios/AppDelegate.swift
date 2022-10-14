//
//  AppDelegate.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import UIKit
import CoreData
import FacebookCore
import FirebaseCore
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var environment: Environment = .none
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        // MARK: Facebook SDK config
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        // MARK: Enviroment setting
        #if PRODUCTION
        environment = .production
        #else
        environment = .development
        #endif
        // MARK: Google Maps config
         switch environment {
         case .development:
             GMSServices.provideAPIKey(ConstantVariables.gmsServicesProvideAPIKeyDevelopment)
             GMSPlacesClient.provideAPIKey(ConstantVariables.gmsPlacesClientProvideAPIKeyDevelopment)
         case .production:
             GMSServices.provideAPIKey(ConstantVariables.gmsServicesProvideAPIKeyProduction)
             GMSPlacesClient.provideAPIKey(ConstantVariables.gmsPlacesClientProvideAPIKeyProduction)
         case .none:
             GMSServices.provideAPIKey("")
             GMSPlacesClient.provideAPIKey("")
         }
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension UIApplication {
    class func isFirstTimeOpening() -> Bool {
        let defaults = ConstantVariables.defaults
        guard defaults.integer(forKey: "hasRun") == 0 else { return false }
        defaults.set(1, forKey: "hasRun")
        return true
    }
}
