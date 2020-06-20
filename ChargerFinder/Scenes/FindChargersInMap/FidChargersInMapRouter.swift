//
//  FidChargersInMapRouter.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 09/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit
import CoreLocation

protocol FindChargersInMapRouterProtocol: AnyObject, Coordinator {
    func showAugmentedRealityChargerFinderView()
}

protocol FindChargersInMapRouterEscapeHandler: Coordinator {}

class FindChargersInMapRouter: FindChargersInMapRouterProtocol {
    private let parentCoordinator: FindChargersInMapRouterEscapeHandler
    private weak var rootViewController: UINavigationController?
    
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
        let findChargersWithARCoordinator = FindChargersWithARRouter(parentRouter: self, rootViewController: navigationController)
        findChargersWithARCoordinator.start()
    }
}

extension FindChargersInMapRouter: FindChargersWithARRouterEscapeHandler {}
