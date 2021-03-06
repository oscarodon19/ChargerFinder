//
//  MainViewController.swift
//  ChangerFinderDemoApp
//
//  Created by Oscar Odon on 10/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit
import ChargerFinder

class MainViewController: UIViewController {
    private let coordinator: MainViewRouter
    
    private lazy var findChargersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to charger finder", for: .normal)
        button.addTarget(self, action: #selector(handleFindChargerButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(coordinator: MainViewRouter) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func handleFindChargerButtonTapped(sender: UIButton) {
        coordinator.handleChargerFinderPush()
    }
}

extension MainViewController: ProgrammaticallyLayoutable {
    func setupViewHierarchy() {
        view.addSubview(findChargersButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            findChargersButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            findChargersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupAditionalConfigurations() {
        view.setSystemBackgroundColor()
    }
}

