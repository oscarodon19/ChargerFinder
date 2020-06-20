//
//  FindChargersWithARPresenter.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 06/06/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import CoreLocation
import MapKit

class FindChargersWithARPresenter: NSObject {
    weak private var viewDelegate: ChargersDisplayable?
    private let interactor: ChargerBusinessLogic
    private let locationManager: CLLocationManager
    private var userHeading = 0.0
    private var headingStep = 0
    
    init(interactor: ChargerBusinessLogic, locationManager: CLLocationManager) {
        self.interactor = interactor
        self.locationManager = locationManager
        super.init()
        interactor.setDelegate(self)
    }
}

extension FindChargersWithARPresenter {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func checkLocationAuthorization(with status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            viewDelegate?.userDidNotAuthorizeLocation()
        }
    }
}

extension FindChargersWithARPresenter: ChargersPresentable {
    func presentFetchedChargers(for response: [Charger]) {
        viewDelegate?.displayFetchedChargers(with: response)
        locationManager.startUpdatingHeading()
    }
}

extension FindChargersWithARPresenter: FindChargersPresenterProtocol {
    func setViewDelegate(_ delegate: ChargersDisplayable) {
        viewDelegate = delegate
    }
    
    func viewDidStart() {
        setupLocationManager()
        interactor.fetchChargers()
    }
}

// MARK: - CLLocationManagerDelegate
extension FindChargersWithARPresenter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        viewDelegate?.didChangeLocation(with: location)
        interactor.fetchChargers()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization(with: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.headingStep += 1
            if self.headingStep < 2 { return }
            self.viewDelegate?.didChangeHeading(with: newHeading, manager)
        }
    }
}


