//
//  UIButtonExtension.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 10/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import Foundation

extension UIButton {
    func setImage(withIdentifier assetIdentifier: AssetIdentifier) {
        if let image = UIImage(assetIdentifier: .augmentedRealityIcon) {
            addImage(image)
        } else {
            debugPrint("Could not load image")
        }
    }
    
    func addImage(_ image: UIImage) {
        if #available(iOS 13.0, *) {
            self.setImage(image, for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
}
