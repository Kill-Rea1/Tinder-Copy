//
//  LoginViewModel.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 15/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class LoginViewModel {
    var email: String? { didSet { checkFormValidity()}}
    var password: String? { didSet { checkFormValidity()}}
    
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsLogining = Bindable<Bool>()
    
    fileprivate func checkFormValidity() {
        let isFormValid = email?.isEmpty == false && password?.isEmpty == false
        self.bindableIsFormValid.value = isFormValid
    }
    
    public func performLogining(completion: @escaping (Error?) -> ()) {
        guard let email = email else { return }
        guard let password = password else { return }
        bindableIsLogining.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
            self.bindableIsLogining.value = false
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
