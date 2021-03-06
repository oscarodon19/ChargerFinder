//
//  FindChargersInMapPresenter.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 09/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import CoreLocation
import MapKit

protocol FindChargersPresenterProtocol: AnyObject {
    func setViewDelegate(_ delegate: ChargersDisplayable)
    func viewDidStart()
}

protocol ChargersPresentable: AnyObject {
    func presentFetchedChargers(for response: [Charger])
}

class FindChargersInMapPresenter: NSObject {
    weak private var viewDelegate: ChargersDisplayable?
    private let interactor: ChargerBusinessLogic
    private let locationManager: CLLocationManager
    
    init(interactor: ChargerBusinessLogic, locationManager: CLLocationManager) {
        self.interactor = interactor
        self.locationManager = locationManager
        super.init()
        interactor.setDelegate(self)
    }
}

extension FindChargersInMapPresenter {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
    }
    
    func checkLocationAuthorization(with status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            guard let locationCoordinates = locationManager.location?.coordinate else { return }
            viewDelegate?.userDidAuthorizeLocation(locationCoordinates)
            locationManager.startUpdatingLocation()
        } else {
            viewDelegate?.userDidNotAuthorizeLocation()
        }
    }
}

extension FindChargersInMapPresenter: ChargersPresentable {
    func presentFetchedChargers(for response: [Charger]) {
        viewDelegate?.displayFetchedChargers(with: response)
    }
}

extension FindChargersInMapPresenter: FindChargersPresenterProtocol {
    func setViewDelegate(_ delegate: ChargersDisplayable) {
        viewDelegate = delegate
    }
    
    func viewDidStart() {
        setupLocationManager()
        interactor.fetchChargers()
    }
}

// MARK: - CLLocationManagerDelegate
extension FindChargersInMapPresenter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        viewDelegate?.didChangeLocation(with: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization(with: status)
    }
}





