//
//  FindChargersInMapViewController.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 09/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import MapKit

protocol FindChargersInMapViewControllerDelegate: AnyObject {
    func userDidAuthorizeLocation(_ coordinates: CLLocationCoordinate2D)
    func userDidNotAuthorizeLocation()
    func didChangeLocation(with coordinates: CLLocationCoordinate2D)
}

class FindChargersInMapViewController: UIViewController {
    
    private let coordinator: FindChargersInMapCoordinator
    private var presenter: FindChargersInMapPresenterProtocol
    private let regionInMeters: Double = 10000

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    init(coordinator: FindChargersInMapCoordinator, presenter: FindChargersInMapPresenterProtocol) {
        self.coordinator = coordinator
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.setViewDelegate(self)
        presenter.viewDidStart()
    }
}

extension FindChargersInMapViewController: FindChargersInMapViewControllerDelegate {
    func userDidAuthorizeLocation(_ coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
    }
    
    func userDidNotAuthorizeLocation() {
        //TODO: Show alert letting the user know they have to turn this on
    }
    
    func didChangeLocation(with coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
}

extension FindChargersInMapViewController: ProgrammaticallyLayoutable {
    func setupViewHierarchy() {
        view.addSubview(mapView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.37),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupAditionalConfigurations() {
        view.setSystemBackground()
    }
}
