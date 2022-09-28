//
//  SceneDelegate.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 1/8/22.
//

import UIKit
import FacebookCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static weak var shared: SceneDelegate?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Self.shared = self
        isFirstLaunch()
        setupRootControllerIfNeeded(validUser: FirebaseAuthManager.shared.userIsLoggedIn())
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window = self.window
        guard scene is UIWindowScene else { return }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

    func isFirstLaunch() {
        let defaults = UserDefaults.standard
        if UIApplication.isFirstTimeOpening() {
            defaults.set(true, forKey: ConstantVariables.deflaunchApp)
        } else {
            defaults.set(false, forKey: ConstantVariables.deflaunchApp)
        }
    }

    func setupRootControllerIfNeeded(validUser: Bool) {
        if validUser {
            let rootViewController = getRootViewControllerForValidUser()
            self.window?.rootViewController = rootViewController
        } else {
            let rootViewController = getRootViewControllerForInvalidUser()
            self.window?.rootViewController = rootViewController
        }
        self.window?.makeKeyAndVisible()
    }

    func getRootViewControllerForInvalidUser() -> UIViewController {
        let navController = UINavigationController(rootViewController: LoginViewController())
        return navController
    }

    func getRootViewControllerForValidUser() -> UIViewController {
        // Create TabBarVC
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.isTranslucent = false
        tabBarVC.tabBar.backgroundColor = .white
        // Add VCs to TabBarVC
        tabBarVC.viewControllers = [
            createNavController(for: RouteListViewController(), title: String.localizeString(localizedString: "home"),
                image: UIImage(systemName: "bus.fill")!),
            createNavController(for: HomeViewController(), title: String.localizeString(localizedString: "tourpoints"),
                image: UIImage(systemName: "mappin.and.ellipse")!),
            createNavController(for: HomeViewController(), title: String.localizeString(localizedString: "map"),
                image: UIImage(systemName: "map.fill")!),
            createNavController(for: HomeViewController(), title: String.localizeString(localizedString: "favorites"),
                image: UIImage(systemName: "suit.heart")!),
            createNavController(for: SettingsViewController(), title: String.localizeString(localizedString: "settings"),
                image: UIImage(systemName: "gearshape.fill")!)
        ]
        return tabBarVC
    }

    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.tintColor = .white

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = ColorConstants.headerColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        navController.modalPresentationStyle = .overFullScreen

        rootViewController.navigationItem.title = title
        return navController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
         CoreDataManager.shared.saveContext()
    }
}
