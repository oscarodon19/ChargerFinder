//
//  LoginViewController.swift
//  ChargerFinderDemoApp
//
//  Created by Oscar Odon on 09/07/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit
import ChargerFinder
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let router: LoginViewRouter
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = String.title
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 45)
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
        textField.minimumFontSize = 17
        textField.isSecureTextEntry = true
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(String.login, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(loginDidTouch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle(String.signup, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(signUpDidTouch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(router: LoginViewRouter) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.router.handleChargerFinderPush()
                self.emailTextfield.text = nil
                self.passwordTextfield.text = nil
            }
        }
    }
}

extension LoginViewController {
    @objc func loginDidTouch(_ sender: AnyObject) {
        guard
            let email = emailTextfield.text,
            let password = passwordTextfield.text,
            email.count > 0,
            password.count > 0
            else { return }
      
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: String.signinFailed,
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: String.ok, style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: String.register, message: String.register, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: String.save, style: .default) { _ in
            let emailField = alert.textFields?[0]
            let passwordField = alert.textFields?[1]
            Auth.auth().createUser(withEmail: emailField?.text ?? "", password: passwordField?.text ?? "") { user, error in
                if error == nil {
                    guard
                        let emailText = self.emailTextfield.text,
                        let passwordText = self.passwordTextfield.text
                        else { return }
                    Auth.auth().signIn(withEmail: emailText, password: passwordText) { user, error in
                        if let error = error, user == nil {
                            let alert = UIAlertController(title: String.signinFailed,
                                                            message: error.localizedDescription,
                                                            preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: String.ok, style: .default))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
      
        let cancelAction = UIAlertAction(title: String.cancel,
                                       style: .cancel)
      
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
          
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
          
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
          
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: ProgrammaticallyLayoutable {
    public func setupViewHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(emailTextfield)
        view.addSubview(passwordTextfield)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
    }
    
    public func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 152),
            emailTextfield.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 116),
            emailTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 54),
            emailTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -54),
            emailTextfield.heightAnchor.constraint(equalToConstant: 40),
            passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 8),
            passwordTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 54),
            passwordTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -54),
            passwordTextfield.heightAnchor.constraint(equalToConstant: 40),
            loginButton.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 54),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -54),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 54),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -54),
        ])
    }
    
    public func setupAditionalConfigurations() {
        view.setSystemBackgroundColor()
    }
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextfield {
      passwordTextfield.becomeFirstResponder()
    }
    if textField == passwordTextfield {
      textField.resignFirstResponder()
    }
    return true
  }
}

fileprivate extension String {
    static let title = "Charger Finder"
    static let login = "Login"
    static let signup = "Sign up"
    static let cancel = "Cancel"
    static let register = "Register"
    static let save = "Save"
    static let ok = "Ok"
    static let signinFailed = "Sign In Failed"
    static let emailPlaceholder = "Email"
    static let passwordPlaceholder = "Password"
}
