//
//  ChargerFinderBundle.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 10/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//
import Foundation

final class ChargerFinderBundle {
    static let resourceBundle: Bundle = {
        let bundle = Bundle(for: ChargerFinderBundle.self)
        
        guard let resourceBundleURL = bundle.url(
            forResource: "ChargerFinder",
            withExtension: "bundle")
            else { fatalError("ChargerFinder.bundle not found!") }
        
        guard let resourceBundle = Bundle(url: resourceBundleURL)
            else { fatalError("Cannot load ChargerFinder.bundle!")}
        
        return resourceBundle
    }()
}
