//
//  ProgrammaticallyLayoutable.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 23/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

public protocol ProgrammaticallyLayoutable {
    func setupView()
    func setupViewHierarchy()
    func setupConstraints()
    func setupAditionalConfigurations()
}

extension ProgrammaticallyLayoutable {
    func setupAditionalConfigurations() {}
}

public extension ProgrammaticallyLayoutable {
    func setupView() {
        setupViewHierarchy()
        setupConstraints()
        setupAditionalConfigurations()
    }
}
