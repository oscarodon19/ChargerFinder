//
//  LoginViewController.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 05/07/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit

public class LoginViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = String.emailPlaceholder
        textField.borderStyle = .roundedRect
        textField.minimumFontSize = 17
        textField.adjustsFontSizeToFitWidth = true
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = String.passwordPlaceholder
        textField.borderStyle = .roundedRect
        textField.borderStyle = .roundedRect
        textField.minimumFontSize = 17
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension LoginViewController: ProgrammaticallyLayoutable {
    public func setupViewHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(emailTextfield)
        view.addSubview(passwordTextfield)
    }
    
    public func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    public func setupAditionalConfigurations() {
        
    }
}

fileprivate extension String {
    static let emailPlaceholder = "Email"
    static let passwordPlaceholder = "Password"
}
