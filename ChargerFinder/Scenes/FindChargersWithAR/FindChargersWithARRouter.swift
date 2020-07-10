//
//  FindChargersWithARRouter.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 25/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit
import CoreLocation

protocol FindChargersWithARRouterProtocol: AnyObject, Router {}
protocol FindChargersWithARRouterEscapeHandler: Router {}

class FindChargersWithARRouter: FindChargersWithARRouterProtocol {
    private let parentRouter: FindChargersWithARRouterEscapeHandler
    private weak var rootViewController: UINavigationController?
    
    public init(parentRouter: FindChargersWithARRouterEscapeHandler, rootViewController: UINavigationController) {
        self.parentRouter = parentRouter
        self.rootViewController = rootViewController
    }
    
    public func start() {
        let interactor = ChargersInteractor()
        let locationManager = CLLocationManager()
        let presenter = FindChargersWithARPresenter(interactor: interactor, locationManager: locationManager)
        let viewController = FindChargersWithARViewController(router: self, presenter: presenter)
        rootViewController?.pushViewController(viewController, animated: true)
    }
}
