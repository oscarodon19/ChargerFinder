//
//  Math.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 23/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import CoreLocation

class Math {
    static func transformDegreesToRadians(_ degrees: Double) -> Double {
        return degrees * Double.pi / 180.0
    }
    
    static func transformRadiansToDegrees(_ radians: Double) -> Double {
        return radians * 180.0 / Double.pi
    }
    
    /// Returns the input value clamped to the lower and upper limits.
    static func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
        return min(max(value, lower), upper)
    }
    
    /// Returns the difference between the angles formed between two specific locations
    static func direction(from p1:CLLocation, to p2: CLLocation) -> Double {
        let longitudeDifference = p2.coordinate.longitude - p1.coordinate.longitude
        
        let y = sin(longitudeDifference) * cos(p2.coordinate.longitude)
        let x = cos(p1.coordinate.latitude) * sin(p2.coordinate.latitude) - sin(p1.coordinate.latitude) * cos(p2.coordinate.latitude) * cos(longitudeDifference)
        let atan_rad = atan2(y, x)
        
        return transformRadiansToDegrees(atan_rad)
    }
}
