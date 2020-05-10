//
//  FidChargersInMapCoordinator.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 09/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit

protocol FindChargersInMapCoordinatorProtocol: AnyObject, Coordinator {
    func didTapAugmentedRealityViewButton()
}
protocol FindChargersInMapCoordinatorEscapeHandler: Coordinator {}

class FindChargersInMapCoordinator: FindChargersInMapCoordinatorProtocol {
    private let parentCoordinator: FindChargersInMapCoordinatorEscapeHandler
    private weak var rootViewController: UINavigationController?
    
    public init(parentCoordinator: FindChargersInMapCoordinatorEscapeHandler, rootViewController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.rootViewController = rootViewController
    }
    
    public func start() {
        let presenter = FindChargersInMapPresenter()
        let viewController = FindChargersInMapViewController(coordinator: self, presenter: presenter)
        rootViewController?.pushViewController(viewController, animated: true)
    }
    
    func didTapAugmentedRealityViewButton() {
        guard let navigationController = rootViewController else { return }
        let findChargersWithARCoordinator = FindChargersWithARCoordinator(parentCoordinator: self, rootViewController: navigationController)
        findChargersWithARCoordinator.start()
    }
}

extension FindChargersInMapCoordinator: FindChargersWithARCoordinatorEscapeHandler {}

