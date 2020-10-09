//
//  FilledButton.swift
//  ChargerFinderDemoApp
//
//  Created by Oscar Odon on 17/09/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit

internal protocol FilledButtonDelegate: AnyObject {
    func didTapButton(_ sender: FilledButton)
}

internal class FilledButtonProtocol: UIButton {}

internal class FilledButton: FilledButtonProtocol {
    private let text: String
    weak private var delegate: FilledButtonDelegate?
    
    internal init(text: String, delegate: FilledButtonDelegate?) {
        self.text = text
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

internal extension FilledButton {
    func setupView() {
        self.setTitle(text, for: .normal)
        backgroundColor = .systemBlue
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func didTapButton() {
        delegate?.didTapButton(self)
    }
}
