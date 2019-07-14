//
//  FooterView.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 12/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class BottomView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    public let refreshButton = createButton(image: #imageLiteral(resourceName: "3 1"))
    public let dislikeButton = createButton(image: #imageLiteral(resourceName: "3 2"))
    public let superLikeButton = createButton(image: #imageLiteral(resourceName: "3 3"))
    public let likeButton = createButton(image: #imageLiteral(resourceName: "3 4"))
    public let specialButton = createButton(image: #imageLiteral(resourceName: "3 5"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        constraintHeight(constant: 100)
        [refreshButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach { (button) in
            addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
