//
//  UIViewExtension.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 10/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//
import UIKit

public extension UIView {
     func setSystemBackground() {
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemBackground
        } else {
            self.backgroundColor = .white
        }
    }
}
