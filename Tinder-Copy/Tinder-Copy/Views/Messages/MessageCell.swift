//
//  MessageCell.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools

class MessageCell: LBTAListCell<Message> {
    
    fileprivate let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 18)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    fileprivate let bubbleContainer = UIView()
    fileprivate var anchoredConstraints: AnchoredConstraints!
    override var item: Message! {
        didSet {
            
            textView.text = item.messageText
            if item.isMessageFromCurrentLoggedUser {
                // right edge
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.07523792237, green: 0.7628311515, blue: 0.9986489415, alpha: 1)
                anchoredConstraints.leading?.isActive = false
                anchoredConstraints.trailing?.isActive = true
                textView.textColor = .white
            } else {
                // left edge
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.9066892862, green: 0.9018284678, blue: 0.9060751796, alpha: 1)
                anchoredConstraints.leading?.isActive = true
                anchoredConstraints.trailing?.isActive = false
                textView.textColor = .black
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        
        anchoredConstraints = bubbleContainer.addConsctraints(leadingAnchor, trailingAnchor, topAnchor, bottomAnchor)
        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.constant = -20
        
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}
