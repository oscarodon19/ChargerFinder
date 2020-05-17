//
//  UIImageExtension.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 10/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit

enum AssetIdentifier: String {
    case augmentedRealityIcon = "augmented_reality"
    case chargerIcon = "charger"
}

extension UIImage {
    convenience init?(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue, in: ChargerFinderBundle.resourceBundle, compatibleWith: nil)
    }
}
