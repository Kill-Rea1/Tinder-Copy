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
        button.layer.cornerRadius = 16
        return button
    }()
    
    fileprivate let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter full name"
        return tf
    }()
    
    fileprivate let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    fileprivate let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    fileprivate let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.constraintHeight(constant: 44)
        button.layer.cornerRadius = 22
        button.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        let stackView = VerticalStackView(arrangedSubviews: [
            selectPhotoButton, fullNameTextField, emailTextField, passwordTextField, registerButton
            ], spacing: 8)
        
        view.addSubview(stackView)
        stackView.addConsctraints(view.leadingAnchor, view.trailingAnchor, nil, nil, .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9976429343, green: 0.3786364794, blue: 0.382350862, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8500358462, green: 0.1086090878, blue: 0.4460129142, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.layer.addSublayer(gradientLayer)
    }
}
