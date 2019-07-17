//
//  MessagesNavBar.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools

class MatchesNavBar: UIView {
    
    public let backButton = UIButton(image: #imageLiteral(resourceName: "3 7"), tintColor: .lightGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        iconImageView.tintColor = #colorLiteral(red: 1, green: 0.4412513971, blue: 0.4679982662, alpha: 1)
        let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 22), textColor: #colorLiteral(red: 1, green: 0.4412513971, blue: 0.4679982662, alpha: 1), textAlignment: .center)
        let feedLabel = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 22), textColor: .gray, textAlignment: .center)
        setupShadow(opacity: 0.35, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        stack(iconImageView.withHeight(40),
                   hstack(messagesLabel, feedLabel, distribution: .fillEqually)).padTop(16)
        addSubview(backButton)
        backButton.addConsctraints(leadingAnchor, nil, safeAreaLayoutGuide.topAnchor, nil, .init(top: 12, left: 8, bottom: 0, right: 0), .init(width: 34, height: 34))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
