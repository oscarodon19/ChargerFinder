//
//  UIColorExtension.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 10/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

enum AssetsColor: String {
    case background
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}
