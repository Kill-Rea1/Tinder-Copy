//
//  MatchesHeader.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 18/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools

class MatchesHeader: UICollectionReusableView {
    
    fileprivate let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 1, green: 0.4412513971, blue: 0.4679982662, alpha: 1))
    public let matchesHorizontalController = MatchesHorizontalController()
    fileprivate let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 1, green: 0.4412513971, blue: 0.4679982662, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stack(stack(newMatchesLabel).padLeft(20),
              matchesHorizontalController.view,
              stack(messagesLabel).padLeft(20),
              spacing: 20).withMargins(.init(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
