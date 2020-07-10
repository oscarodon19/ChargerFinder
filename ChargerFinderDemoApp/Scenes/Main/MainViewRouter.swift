//
//  MainViewCoordinator.swift
//  ChargerFinderDemoApp
//
//  Created by Oscar Odon on 23/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import ChargerFinder

protocol MainViewRouterProtocol: AnyObject, Router {
    func handleChargerFinderPush()
}
protocol MainViewRouterScapeHandler: Router {
    func handleChargerFinderNavigation()
}

class MainViewRouter: MainViewRouterProtocol {
    private let parentRouter: MainViewRouterScapeHandler
    private weak var rootViewController: UINavigationController?
    
    init(parentRouter: MainViewRouterScapeHandler, rootViewController: UINavigationController) {
        self.parentRouter = parentRouter
        self.rootViewController = rootViewController
    }
    
    func start() {
        let mainViewController = MainViewController(coordinator: self)
        self.rootViewController?.setViewControllers([mainViewController], animated: false)
    }
    
    func handleChargerFinderPush() {
        parentRouter.handleChargerFinderNavigation()
    }
}
