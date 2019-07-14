//
//  Bindable.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 14/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
