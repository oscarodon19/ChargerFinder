//
//  LoginViewRouter.swift
//  ChargerFinderDemoApp
//
//  Created by Oscar Odon on 09/07/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import ChargerFinder

protocol LoginViewRouterProtocol: AnyObject, Router {
    func handleChargerFinderPush()
}
protocol LoginViewRouterScapeHandler: Router {
    func handleChargerFinderNavigation()
}

class LoginViewRouter: LoginViewRouterProtocol {
    private let parentRouter: LoginViewRouterScapeHandler
    private weak var rootViewController: UINavigationController?
    
    init(parentRouter: LoginViewRouterScapeHandler, rootViewController: UINavigationController) {
        self.parentRouter = parentRouter
        self.rootViewController = rootViewController
    }
    
    func start() {
        let loginViewController = LoginViewController(router: self)
        self.rootViewController?.setViewControllers([loginViewController], animated: false)
    }
    
    func handleChargerFinderPush() {
        parentRouter.handleChargerFinderNavigation()
    }
}
