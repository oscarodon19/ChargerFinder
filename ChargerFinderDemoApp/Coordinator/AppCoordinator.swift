//
//  AppCoordinator.swift
//  ChargerFinderDemoApp
//
//  Created by Oscar Odon on 23/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit
import ChargerFinder
import FirebaseAuth

class AppCoordinator: Router {
    private let window: UIWindow
    private var rootViewController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        rootViewController = UINavigationController(rootViewController: UIViewController())
        rootViewController?.setTranslucentNavigationBar()
        guard let navigationController = rootViewController else { return }
        let mainRouter = LoginViewRouter(
            parentRouter: self,
            rootViewController: navigationController
        )
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        mainRouter.start()
    }
}

extension AppCoordinator: LoginViewRouterScapeHandler {
    func handleChargerFinderNavigation() {
        guard let navigationController = rootViewController else { return }
        let chargerFinderCoordinator = ChargerFinderCoordinator(
                                        parentCoordinator: self,
                                        rootViewController:  navigationController)
        chargerFinderCoordinator.start()
    }
}

extension AppCoordinator: ChargerFinderCoordinatorEscapeHandler {
    func didEndModuleFlow() {
        guard let user = Auth.auth().currentUser else { return }
        do {
            try Auth.auth().signOut()
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
}
