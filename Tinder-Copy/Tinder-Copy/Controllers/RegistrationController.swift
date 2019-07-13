//
//  RegistrationController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 13/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    fileprivate let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.constraintHeight(constant: 275)
        button.constraintWidth(constant: 275)
        button.layer.cornerRadius = 16
        return button
    }()
    
    fileprivate let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter full name"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    fileprivate let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    fileprivate let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    fileprivate let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.constraintHeight(constant: 50)
        button.layer.cornerRadius = 25
//        button.backgroundColor = UIColor(white: 0, alpha: 0.2)
        button.backgroundColor = .lightGray
        button.setTitleColor(.darkGray, for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    lazy var verticalStackView: VerticalStackView = {
        let sv = VerticalStackView(arrangedSubviews: [
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton], spacing: 8)
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoButton, verticalStackView
        ], customSpacing: 8)
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate let registrationViewModel = RegistationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupNotificationsObservers()
        setupTagGesture()
        setupRegistrationViewModelObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
    }
    
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.isFormValidObserver = { [weak self] (isFormValid) in
            self?.registerButton.isEnabled = isFormValid
            self?.registerButton.backgroundColor = isFormValid ? UIColor(white: 0, alpha: 0.2) : .lightGray
        }
    }
    
    @objc fileprivate func handleTextChange(textField: CustomTextField) {
        switch textField {
        case fullNameTextField:
            registrationViewModel.fullName = textField.text
        case emailTextField:
            registrationViewModel.email = textField.text
        default:
            registrationViewModel.password = textField.text
        }
    }
    
    fileprivate func setupTagGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }
    
    fileprivate func setupNotificationsObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleShowKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    @objc fileprivate func handleHideKeyboard() {
        view.transform = .identity
    }
    
    fileprivate func setupLayout() {
        view.addSubview(stackView)
        stackView.addConsctraints(view.leadingAnchor, view.trailingAnchor, nil, nil, .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
