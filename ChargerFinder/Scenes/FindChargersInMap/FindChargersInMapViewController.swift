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
    private let regionInMeters: Double = 1000
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        let alert = UIAlertController(title: "Location Access Required", message: "We need location access permits to use maps features", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func didChangeLocation(with coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
}

extension FindChargersInMapViewController: ProgrammaticallyLayoutable {
    func setupViewHierarchy() {
        stackView.addArrangedSubview(mapView)
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.37)
        ])
    }
    
    func setupAditionalConfigurations() {
        view.setSystemBackgroundColor()
        navigationItem.title = "Charger Finder"
    }
}
