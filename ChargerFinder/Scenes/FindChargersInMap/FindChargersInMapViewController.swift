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
    //TODO: Delete the array below when parse data from firebase
    private var chargers = ["Charger 1","Charger 2","Changer 3", "Charger 4"]
    
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var augmentedRealityButton: UIButton = {
        let button = UIButton()
        button.setImage(withIdentifier: .augmentedRealityIcon)
        button.addTarget(self, action: #selector(handleAugmentedRealityButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    
    @objc private func handleAugmentedRealityButtonTapped() {
        coordinator.didTapAugmentedRealityViewButton()
    }
}

//MARK: - ViewControllerDelegate
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

// MARK: - ProgramaticallyLayoutable
extension FindChargersInMapViewController: ProgrammaticallyLayoutable {
    func setupViewHierarchy() {
        mapView.addSubview(augmentedRealityButton)
        stackView.addArrangedSubview(mapView)
        stackView.addArrangedSubview(tableView)
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.37),
            augmentedRealityButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -15),
            augmentedRealityButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -32),
            augmentedRealityButton.heightAnchor.constraint(equalToConstant: 50),
            augmentedRealityButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupAditionalConfigurations() {
        view.setSystemBackgroundColor()
        navigationItem.title = "Charger Finder"
    }
}

//MARK: - TableDataSourceDelegate
extension FindChargersInMapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = chargers[indexPath.section]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return chargers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.appColor(.divider)
        return view
    }
}

//MARK: - TableViewDelegate
extension FindChargersInMapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Implement logic to navigate to detail view
    }
}