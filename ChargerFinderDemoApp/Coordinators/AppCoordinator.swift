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
    private var rootViewController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        rootViewController = UINavigationController(rootViewController: UIViewController())
        rootViewController?.setTranslucentNavigationBar()
        guard let navigationController = rootViewController else { return }
        let mainCoordinator = MainViewCoordinator(
            parentCoordinator: self,
            rootViewController: navigationController
        )
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        mainCoordinator.start()
    }
}

extension AppCoordinator: MainViewCoordinatorScapeHandler {
    func handleChargerFinderNavigation() {
        guard let navigationController = rootViewController else { return }
        let chargerFinderCoordinator = ChargerFinderCoordinator(
                                        parentCoordinator: self,
                                        rootViewController:  navigationController)
        chargerFinderCoordinator.start()
    }
}

extension AppCoordinator: ChargerFinderCoordinatorEscapeHandler {}
