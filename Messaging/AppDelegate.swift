//
//  AppDelegate.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 14/10/22.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        updateParentView()
        return true
    }

    func getUserStatus() -> Bool {
        return UserDefaults.isUserLoggedIn
    }

    func updateParentView() {
        self.window     =   UIWindow(frame: UIScreen.main.bounds)
        let tabBarVC    =   TabBarViewController()
        let loginVC     =   LoginViewController()
        let naviVC      =   UINavigationController(rootViewController: loginVC)
        self.window?.rootViewController = getUserStatus() ? tabBarVC : naviVC
        self.window?.makeKeyAndVisible()
    }
}

