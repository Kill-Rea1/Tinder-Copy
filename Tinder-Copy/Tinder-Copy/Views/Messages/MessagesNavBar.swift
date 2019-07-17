//
//  MessagesNavBar.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools

class MessagesNavBar: UIView {
    
    fileprivate let match: Match
    
    fileprivate let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "jane3"))
    fileprivate let userNameLabel = UILabel(text: "Name", font: .systemFont(ofSize: 16), textAlignment: .center)
    fileprivate let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 1, green: 0.4412513971, blue: 0.4679982662, alpha: 1))
    public let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 1, green: 0.4412513971, blue: 0.4679982662, alpha: 1))
    
    init(match: Match) {
        self.match = match
        userNameLabel.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        super.init(frame: .zero)
        backgroundColor = .white
        setupShadow(opacity: 0.35, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        hstack(backButton,
               stack(userProfileImageView,
                     userNameLabel,
                     spacing: 8,
                     alignment: .center),
               flagButton,
               alignment: .center
            ).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
