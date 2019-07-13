//
//  RegistrationViewModel.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 14/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class RegistationViewModel {
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? { didSet {checkFormValidity()}}
    var password: String? { didSet {checkFormValidity()}}
    
    // Reactive programming
    var isFormValidObserver: ((Bool) -> ())?
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
}
