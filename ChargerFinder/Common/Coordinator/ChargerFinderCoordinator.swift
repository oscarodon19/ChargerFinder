//
//  ChargerFinderCoordinator.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 25/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import Foundation
import UIKit

protocol ChargerFinderCoordinatorProtocol: AnyObject, Coordinator {}
public protocol ChargerFinderCoordinatorEscapeHandler: Coordinator {}

public class ChargerFinderCoordinator: ChargerFinderCoordinatorProtocol {
    private let parentCoordinator: ChargerFinderCoordinatorEscapeHandler
    private weak var rootViewController: UINavigationController?
    
    public init(parentCoordinator: ChargerFinderCoordinatorEscapeHandler, rootViewController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.rootViewController = rootViewController
    }
    
    public func start() {
        guard let navigationController = rootViewController else { return }
        let findChargersWithARCoordinator = FindChargersInMapRouter(parentCoordinator: self, rootViewController: navigationController)
        findChargersWithARCoordinator.start()
    }
}

extension ChargerFinderCoordinator: FindChargersInMapRouterEscapeHandler {}
