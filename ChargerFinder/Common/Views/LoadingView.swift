//
//  LoadingView.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 17/05/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.Error.initNotImplemented)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func startAnimating() {
        spinner.startAnimating()
    }
    
    func stopAnimating() {
        spinner.stopAnimating()
    }
}

extension LoadingView: ProgrammaticallyLayoutable {
    func setupViewHierarchy() {
        addSubview(blurView)
        blurView.contentView.addSubview(spinner)
    }
    
    func setupConstraints() {
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: superview.heightAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            spinner.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor)
        ])
    }
    
    func setupAditionalConfigurations() {}
}
