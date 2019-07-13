//
//  CustomTexttField.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 13/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    let padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = 25
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
}
