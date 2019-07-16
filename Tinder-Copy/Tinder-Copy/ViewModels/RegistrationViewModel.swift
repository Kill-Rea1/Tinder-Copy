//
//  RegistrationViewModel.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 14/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class RegistationViewModel {
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? { didSet {checkFormValidity()}}
    var password: String? { didSet {checkFormValidity()}}
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email else { return }
        guard let password = password else { return }
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            if let error = error {
                completion(error)
                return
            }
            self.saveImageToFirebase(completion: completion)
        }
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "fullName": fullName ?? "",
            "uid": uid,
            "imageUrl1": imageUrl,
            "age": 18,
            "minSeekingAge": User.defaultMinSeekingAge,
            "maxSeekingAge": User.defaultMaxSeekingAge
        ]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping ((Error?)->())) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, error) in
            if let error = error {
                completion(error)
                return
            }
            ref.downloadURL(completion: { (url, error) in
                if let error = error {
                    completion(error)
                    return
                }
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
                self.bindableIsRegistering.value = false
                completion(nil)
            })
        })
    }
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableIsFormValid.value = isFormValid
    }
}
