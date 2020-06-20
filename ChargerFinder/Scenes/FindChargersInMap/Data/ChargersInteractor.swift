//
//  ChargersInteractor.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 16/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ChargersInteractorProtocol: AnyObject {
    func setDelegate(_ delegate: ChargersPresentable)
}

protocol ChargerBusinessLogic: ChargersInteractorProtocol {
    func fetchChargers()
}

class ChargersInteractor {
    private let chargersWorker: DatabaseReference
    weak private var presenter: ChargersPresentable?
    
    init(chargersWorker: DatabaseReference = Database.database().reference(withPath: "chargers")) {
        self.chargersWorker = chargersWorker
    }
}

extension ChargersInteractor: ChargerBusinessLogic {
    func setDelegate(_ presenter: ChargersPresentable) {
        self.presenter = presenter
    }
    
    func fetchChargers() {
        var response = [Charger]()
        chargersWorker.queryOrdered(byChild: "name").observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let charger = Charger(snapshot: snapshot) {
                    response.append(charger)
                }
            }
            self.presenter?.presentFetchedChargers(for: response)
        })
    }
}
