//
//  FindChargersInMapPresenter.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 09/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import CoreLocation
import MapKit

protocol FindChargersInMapPresenterProtocol: AnyObject {
    func setViewDelegate(_ delegate: FindChargersInMapViewControllerDelegate)
    func viewDidStart()
}

class FindChargersInMapPresenter: NSObject {
    weak private var viewDelegate: FindChargersInMapViewControllerDelegate?
    private let locationManager = CLLocationManager()
    
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

extension FindChargersInMapPresenter: FindChargersInMapPresenterProtocol {
    func setViewDelegate(_ delegate: FindChargersInMapViewControllerDelegate) {
        viewDelegate = delegate
    }
    
    func viewDidStart() {
        setupLocationManager()
    }
}

// MARK: - CLLocationManagerDelegate
extension FindChargersInMapPresenter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let locationCoordinates = location.coordinate
        viewDelegate?.didChangeLocation(with: locationCoordinates)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization(with: status)
    }
}





