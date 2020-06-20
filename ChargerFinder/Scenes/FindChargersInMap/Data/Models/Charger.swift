//
//  Charger.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 16/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Charger {
    let ref: DatabaseReference?
    let key: String
    let name: String
    let address: String
    let availability: String
    let latitude: Double
    let longitude: Double
    let description: String
    let highPower: Bool
    let inUse: Bool
    let locationType: String
    let payment: String
    let plugScore: String
    let plugType: String
    let solarPowered: Bool
    let state: String
    
    init(name: String, address: String, availability: String, latitude: Double, longitude: Double, description: String, highPower: Bool, inUse: Bool, locationType: String, payment: String, plugScore: String, plugType: String, solarPowered: Bool, state: String, key: String = String.empty) {
        self.ref = nil
        self.key = key
        self.name = name
        self.address = address
        self.availability = availability
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.highPower = highPower
        self.inUse = inUse
        self.locationType = locationType
        self.payment = payment
        self.plugScore = plugScore
        self.plugType = plugType
        self.solarPowered = solarPowered
        self.state = state
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let address = value["address"] as? String,
            let availability = value["availability"] as? String,
            let latitude = value["latitude"] as? Double,
            let longitude = value["longitude"] as? Double,
            let description = value["description"] as? String,
            let highPower = value["high_power"] as? Bool,
            let inUse = value["in_use"] as? Bool,
            let locationType = value["location_type"] as? String,
            let payment = value["payment"] as? String,
            let plugScore = value["plug_score"] as? String,
            let plugType = value["plug_type"] as? String,
            let solarPowered = value["solar_powered"] as? Bool,
            let state = value["state"] as? String else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.address = address
        self.availability = availability
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.highPower = highPower
        self.inUse = inUse
        self.locationType = locationType
        self.payment = payment
        self.plugScore = plugScore
        self.plugType = plugType
        self.solarPowered = solarPowered
        self.state = state
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "address": address,
            "availability": availability,
            "latitude": latitude,
            "longitude": longitude,
            "description": description,
            "high_power": highPower,
            "in_use": inUse,
            "location_type": locationType,
            "payment": payment,
            "plug_score": plugScore,
            "plug_type": plugType,
            "solar_powered": solarPowered,
            "state": state
        ]
    }
}

