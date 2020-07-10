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
    
    public init(parentRouter: ChargerDetailRouterEscapeHandler, rootViewController: UINavigationController) {
        self.parentRouter = parentRouter
        self.rootViewController = rootViewController
    }
    
    public func start() {
        
    }
}
