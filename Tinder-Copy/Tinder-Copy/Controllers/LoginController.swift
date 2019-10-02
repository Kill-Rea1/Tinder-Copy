//
//  LoginController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 15/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol LoginControllerDelegate {
    func didFinishLoggingIn()
}

class LoginController: UIViewController {
    
    fileprivate let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter Email"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        return tf
    }()
    
    fileprivate let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter Password"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        return tf
    }()
    
    fileprivate let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.constraintHeight(constant: 44)
        button.layer.cornerRadius = 22
        button.isEnabled = false
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    fileprivate let goToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleGoToRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var overralStackView = VerticalStackView(arrangedSubviews: [
        emailTextField, passwordTextField, loginButton
        ], spacing: 16)
    
    fileprivate let loginHud = JGProgressHUD(style: .dark)
    fileprivate let loginViewModel = LoginViewModel()
    fileprivate let gradientLayer = CAGradientLayer()
    public var delegate: LoginControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotificationsObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupLoginViewModelObserver()
        setupTapGesture()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setupNotificationsObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleShowKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - overralStackView.frame.origin.y - overralStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        if difference > 0 {
            view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        }
    }
    
    @objc fileprivate func handleHideKeyboard() {
        view.transform = .identity
    }
    
    @objc fileprivate func handleLogin() {
        handleTap()
        loginViewModel.performLogining { [unowned self] (error) in
            if let error = error {
                self.showHUDWithError(error: error)
                return
            }
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishLoggingIn()
            })
        }
    }
    
    fileprivate func showHUDWithError(error: Error) {
        loginHud.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed login"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: view)
        hud.dismiss(afterDelay: 2)
    }
    
    fileprivate func setupLoginViewModelObserver() {
        loginViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.loginButton.isEnabled = isFormValid
            self.loginButton.backgroundColor = isFormValid ? UIColor(white: 0, alpha: 0.2) : .lightGray
        }
        loginViewModel.bindableIsLogining.bind { [unowned self] (isLogining) in
            guard let isLogining = isLogining else { return }
            if isLogining {
                self.loginHud.textLabel.text = "Login.."
                self.loginHud.show(in: self.view)
            } else {
                self.loginHud.dismiss()
            }
        }
    }
    
    @objc fileprivate func handleTextFieldChange(textField: CustomTextField) {
        switch textField {
        case emailTextField:
            loginViewModel.email = textField.text
        default:
            loginViewModel.password = textField.text
        }
    }
    
    fileprivate func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    @objc fileprivate func handleGoToRegister() {
        let registrationController = RegistrationController()
        registrationController.delegate = delegate
        navigationController?.pushViewController(registrationController, animated: true)
    }
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(overralStackView)
        overralStackView.addConsctraints(view.leadingAnchor, view.trailingAnchor, nil, nil, .init(top: 0, left: 50, bottom: 0, right: 50))
        overralStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(goToRegisterButton)
        goToRegisterButton.addConsctraints(view.leadingAnchor, view.trailingAnchor, nil, view.safeAreaLayoutGuide.bottomAnchor, .init(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9976429343, green: 0.3786364794, blue: 0.382350862, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8500358462, green: 0.1086090878, blue: 0.4460129142, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
}
