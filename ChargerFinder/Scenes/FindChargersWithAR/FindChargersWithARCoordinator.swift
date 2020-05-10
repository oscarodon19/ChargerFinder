//
//  FindChargersWithARCoordinator.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 25/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit

protocol FindChargersWithARCoordinatorProtocol: AnyObject, Coordinator {}
protocol FindChargersWithARCoordinatorEscapeHandler: Coordinator {}

class FindChargersWithARCoordinator: FindChargersWithARCoordinatorProtocol {
    private let parentCoordinator: FindChargersWithARCoordinatorEscapeHandler
    private weak var rootViewController: UINavigationController?
    
    public init(parentCoordinator: FindChargersWithARCoordinatorEscapeHandler, rootViewController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.rootViewController = rootViewController
    }
    
    public func start() {
        let viewController = FindChargersWithARViewController(coordinator: self)
        rootViewController?.pushViewController(viewController, animated: true)
    }
}
