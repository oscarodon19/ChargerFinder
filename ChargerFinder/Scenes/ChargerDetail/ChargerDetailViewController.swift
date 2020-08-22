//
//  ChargerDetailViewController.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 10/07/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit

class ChargerDetailViewController: UIViewController {
    private var viewModel: Charger
    private let router: ChargerDetailRouter
    
    private lazy var chargerNameLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.name
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = UIColor.appColor(.title)
        view.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerView: UIStackView = {
       let view = UIStackView()
       view.axis = .vertical
       view.distribution = .fill
       view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
       view.isLayoutMarginsRelativeArrangement = true
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 14
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String.description
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
   
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.description
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String.address
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.address
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var locationTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String.locationType
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var locationTypeLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.locationType
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var plugTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String.plugType
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var plugTypeLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.plugType
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var fastChargeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String.fastCharge
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var fastChargeLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.highPower ? String.yes : String.no
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var solarPoweredTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String.solarPowered
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var solarPoweredLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.solarPowered ? String.yes : String.no
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - ViewController Lifecycle
    init(router: ChargerDetailRouter, viewModel: Charger) {
        self.router = router
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.Error.initNotImplemented)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension ChargerDetailViewController: ProgrammaticallyLayoutable {
    func setupViewHierarchy() {
        containerView.addArrangedSubview(chargerNameLabel)
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(descriptionTitleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(addressTitleLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(locationTypeTitleLabel)
        stackView.addArrangedSubview(locationTypeLabel)
        stackView.addArrangedSubview(plugTypeTitleLabel)
        stackView.addArrangedSubview(plugTypeLabel)
        stackView.addArrangedSubview(fastChargeTitleLabel)
        stackView.addArrangedSubview(fastChargeLabel)
        stackView.addArrangedSubview(solarPoweredTitleLabel)
        stackView.addArrangedSubview(solarPoweredLabel)
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupAditionalConfigurations() {
        view.setSystemBackgroundColor()
    }
}

fileprivate extension String {
    static let yes = NSLocalizedString("yes", comment: "Yes string")
    static let no = NSLocalizedString("no", comment: "No string")
    static let fastCharge = NSLocalizedString("fastCharge", comment: "Fast charge title")
    static let solarPowered = NSLocalizedString("solarPowered", comment: "Solar powered charger title")
    static let plugType = NSLocalizedString("plugType", comment: "Charger plug type title")
    static let locationType = NSLocalizedString("locationType", comment: "Charger location type title")
    static let description = NSLocalizedString("description", comment: "Description title")
    static let address = NSLocalizedString("address", comment: "Adress title")
}
