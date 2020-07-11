//
//  ChargerDetailRouter.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 10/07/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit
import CoreLocation

protocol ChargerDetailRouterProtocol: AnyObject, Router {}
protocol ChargerDetailRouterEscapeHandler: Router {}

class ChargerDetailRouter: ChargerDetailRouterProtocol {
    private let parentRouter: ChargerDetailRouterEscapeHandler
    private weak var rootViewController: UINavigationController?
    private let viewModel: Charger
    
    public init(parentRouter: ChargerDetailRouterEscapeHandler, rootViewController: UINavigationController, viewModel: Charger) {
        self.parentRouter = parentRouter
        self.rootViewController = rootViewController
        self.viewModel = viewModel
    }
    
    public func start() {
        let chargerDetailViewController = ChargerDetailViewController(router: self, viewModel: viewModel)
        rootViewController?.present(chargerDetailViewController, animated: true, completion: nil)
    }
}
