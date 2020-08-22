//
//  FindChargersInMapViewController.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 09/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import MapKit

protocol Locatable: AnyObject {
    func userDidAuthorizeLocation(_ coordinates: CLLocationCoordinate2D)
    func userDidNotAuthorizeLocation()
    func didChangeLocation(with location: CLLocation)
    func didChangeHeading(with newHeading: CLHeading, _ manager: CLLocationManager)
}

extension Locatable {
    func didChangeHeading(with newHeading: CLHeading, _ manager: CLLocationManager) {}
}

protocol ChargersDisplayable: Locatable {
    func displayFetchedChargers(with viewModel: [Charger])
}

class FindChargersInMapViewController: UIViewController, Loadable {
    //MARK: - Parameters
    var loadingView: LoadingView?
    private let router: FindChargersInMapRouterProtocol
    private var presenter: FindChargersPresenterProtocol
    private let regionInMeters: Double = 10000
    private var viewModel = [Charger]()
    
    
    //MARK: - UIComponents
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 14
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
    
    private lazy var containerView: UIStackView = {
       let view = UIStackView()
       view.axis = .vertical
       view.distribution = .fill
       view.layoutMargins = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 0)
       view.isLayoutMarginsRelativeArrangement = true
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    private lazy var tableTitle: UILabel = {
        let label = UILabel()
        label.text = String.nearbyChargers
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = UIColor.appColor(.title)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - ViewController Lifecycle
    init(coordinator: FindChargersInMapRouterProtocol, presenter: FindChargersPresenterProtocol) {
        self.router = coordinator
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
        displayLoading()
    }
}

extension FindChargersInMapViewController {
    @objc private func handleAugmentedRealityButtonTapped() {
        router.showAugmentedRealityChargerFinderView()
    }
    
    private func createAnnotations(for chargers: [Charger]) {
        for charger in chargers {
            let annotation = MKPointAnnotation()
            annotation.title = charger.name
            annotation.subtitle = charger.description
            annotation.coordinate = CLLocationCoordinate2D(latitude: charger.latitude, longitude: charger.longitude)
            mapView.addAnnotation(annotation)
        }
    }
}

//MARK: - ChargersDisplayable
extension FindChargersInMapViewController: ChargersDisplayable {
    func displayFetchedChargers(with viewModel: [Charger]) {
        self.viewModel = viewModel
        self.tableView.reloadData()
        createAnnotations(for: viewModel)
        dismissLoading()
    }
}

//MARK: - Locatable
extension FindChargersInMapViewController: Locatable {
    func userDidAuthorizeLocation(_ coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
    }
    
    func userDidNotAuthorizeLocation() {
        let alert = UIAlertController(title: String.locationAccsessRequired, message: String.weNeedLocationAccess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String.dismiss, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func didChangeLocation(with location: CLLocation) {
        let coordinate = location.coordinate
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - ProgramaticallyLayoutable
extension FindChargersInMapViewController: ProgrammaticallyLayoutable {
    func setupViewHierarchy() {
        mapView.addSubview(augmentedRealityButton)
        containerView.addArrangedSubview(tableTitle)
        stackView.addArrangedSubview(mapView)
        stackView.addArrangedSubview(containerView)
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
        navigationItem.title = String.chargerFinder
    }
}

//MARK: - TableDataSourceDelegate
extension FindChargersInMapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = viewModel[indexPath.section].name
        let detail = viewModel[indexPath.section].description
        let cell = CustomTableViewCell(title: title, detail: detail, style: .subtitle, reuseIdentifier: "cell")
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
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
        tableView.deselectRow(at: indexPath, animated: true)
        router.showChargerDetail(viewModel[indexPath.section])
    }
}

fileprivate extension String {
    static let chargerFinder = NSLocalizedString("chargerFinder", comment: "app name")
    static let locationAccsessRequired = NSLocalizedString("locationAccessRequired", comment: "Location Access title text")
    static let weNeedLocationAccess = NSLocalizedString("weNeedLocationAccess", comment: "Location Access descrption text")
    static let dismiss = NSLocalizedString("dismiss", comment: "Dismiss text for dismiss button")
    static let nearbyChargers = NSLocalizedString("nearbyChargers", comment: "Nearby Chargers title")
}
