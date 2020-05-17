//
//  UIColorExtension.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 10/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//
import UIKit

enum AssetsColor: String {
    case background
    case title
    case divider
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue, in: ChargerFinderBundle.resourceBundle, compatibleWith: nil)
    }
}
