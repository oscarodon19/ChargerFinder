//
//  MainViewCoordinator.swift
//  ChargerFinderDemoApp
//
//  Created by Oscar Odon on 23/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import ChargerFinder

protocol MainViewCoordinatorProtocol: AnyObject, Coordinator {}
protocol MainViewCoordinatorScapeHandler: Coordinator {}

class MainViewCoordinator: MainViewCoordinatorProtocol {
    private let parentCoordinator: MainViewCoordinatorScapeHandler
    private weak var rootViewController: UINavigationController?
    
    init(parentCoordinator: MainViewCoordinatorScapeHandler, rootViewController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.rootViewController = rootViewController
    }
    
    func start() {
        let mainViewController = MainViewController(coordinator: self)
        self.rootViewController?.setViewControllers([mainViewController], animated: false)
    }
}
