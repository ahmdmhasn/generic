//
//  AppDelegate.swift
//  Generic
//
//  Created by Ahmed M. Hassan on 04/03/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        return true
    }
}

/// Handlers
///
extension AppDelegate {
    
    func setupWindow() {
        let window = UIWindow()
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

