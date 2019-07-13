//
//  HeaderView.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 12/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class HeaderView: UIStackView {
    
    fileprivate let titleImageView = UIImageView(image: #imageLiteral(resourceName: "3 7"))
    public let settingsButton = UIButton(image: #imageLiteral(resourceName: "3 6"))
    public let messageButton = UIButton(image: #imageLiteral(resourceName: "3 8"))
    
    override init(frame: CGRect) {
        
        titleImageView.contentMode = .scaleAspectFit
        super.init(frame: frame)
        [settingsButton, UIView(), titleImageView, UIView(), messageButton].forEach({ (v) in
            addArrangedSubview(v)
        })
        distribution = .equalCentering
        constraintHeight(constant: 80)
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
