//
//  AppDelegate.swift
//  ChangerFinderDemoApp
//
//  Created by Oscar Odon on 10/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        
        return true
    }

}

