//
//  AppCoordinator.swift
//  ChargerFinderDemoApp
//
//  Created by Oscar Odon on 23/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//
import UIKit
import ChargerFinder

class AppCoordinator: Coordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootViewController = UINavigationController(rootViewController: UIViewController())
        rootViewController.navigationBar
        let mainCoordinator = MainViewCoordinator(
            parentCoordinator: self,
            rootViewController: rootViewController
        )
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        mainCoordinator.start()
    }
}

extension AppCoordinator: MainViewCoordinatorScapeHandler {}
