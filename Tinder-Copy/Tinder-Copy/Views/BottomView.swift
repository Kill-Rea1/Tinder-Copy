//
//  FooterView.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 12/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class BottomView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let subviews = [#imageLiteral(resourceName: "3 1"), #imageLiteral(resourceName: "3 2"), #imageLiteral(resourceName: "3 3"), #imageLiteral(resourceName: "3 4"), #imageLiteral(resourceName: "3 5")].map { (image) -> UIView in
            let button = UIButton(image: image)
            return button
        }
        distribution = .fillEqually
        subviews.forEach({ (v) in
            addArrangedSubview(v)
        })
        constraintHeight(constant: 100)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
