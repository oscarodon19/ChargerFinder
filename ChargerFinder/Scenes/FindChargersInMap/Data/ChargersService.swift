//
//  ChargersService.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 16/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ChargersServiceDelegate: AnyObject {
    func dataDidChange(_ data:[Charger])
}

class ChargersService {
    private let ref = Database.database().reference(withPath: "chargers")
    weak private var delegate: ChargersServiceDelegate?
    
    func setDelegate(_ delegate: ChargersServiceDelegate) {
        self.delegate = delegate
    }
        
    func fetchChargersData() {
        var newItems = [Charger]()
        ref.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let charger = Charger(snapshot: snapshot) {
                    newItems.append(charger)
                }
            }
            self.delegate?.dataDidChange(newItems)
        })
    }
}
