//
//  FidChargersInMapRouter.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 09/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit
import CoreLocation

protocol FindChargersInMapRouterProtocol: AnyObject, Router {
    func showAugmentedRealityChargerFinderView()
    func showChargerDetail(_ viewModel: Charger)
}

protocol FindChargersInMapRouterEscapeHandler: Router {
    func didDeinit()
}

class FindChargersInMapRouter: FindChargersInMapRouterProtocol, ChargerDetailRouterEscapeHandler, FindChargersWithARRouterEscapeHandler {
    private let parentCoordinator: FindChargersInMapRouterEscapeHandler
    private weak var rootViewController: UINavigationController?
    
    deinit {
        parentCoordinator.didDeinit()
    }
    
    public init(parentCoordinator: FindChargersInMapRouterEscapeHandler, rootViewController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.rootViewController = rootViewController
    }
    
    public func start() {
        let interactor = ChargersInteractor()
        let locationManager = CLLocationManager()
        let presenter = FindChargersInMapPresenter(interactor: interactor, locationManager: locationManager)
        let viewController = FindChargersInMapViewController(coordinator: self, presenter: presenter)
        rootViewController?.pushViewController(viewController, animated: true)
    }
    
    func showAugmentedRealityChargerFinderView() {
        guard let navigationController = rootViewController else { return }
        let findChargersWithARRouter = FindChargersWithARRouter(parentRouter: self, rootViewController: navigationController)
        findChargersWithARRouter.start()
    }
    
    func showChargerDetail(_ viewModel: Charger) {
        guard let navigationController = rootViewController else { return }
        let chargerDetailRouter = ChargerDetailRouter(parentRouter: self, rootViewController: navigationController, viewModel: viewModel)
        chargerDetailRouter.start()
    }
}
