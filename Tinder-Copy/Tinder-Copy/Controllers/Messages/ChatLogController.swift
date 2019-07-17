//
//  ChatLogController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools

struct Message {
    let messageText: String
    let isMessageFromCurrentLoggedUser: Bool
}

class MessageCell: LBTAListCell<Message> {
    
    fileprivate let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 20)
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

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MessagesNavBar(match: self.match)
    fileprivate let navHeight: CGFloat = 120
    fileprivate let match: Match 
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
        items = [
            .init(messageText: "hello", isMessageFromCurrentLoggedUser: true),
            .init(messageText: "isMessageFromCurrentLoggedUserisMessageFromCurrentLoggedUserisMessageFromCurrentLoggedUser", isMessageFromCurrentLoggedUser: false),
            .init(messageText: "QWEQWE", isMessageFromCurrentLoggedUser: true),
            .init(messageText: "this new text", isMessageFromCurrentLoggedUser: true)
        ]
        
        collectionView.backgroundColor = .white
        view.addSubview(customNavBar)
        customNavBar.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, nil, .zero, .init(width: 0, height: navHeight))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        collectionView.contentInset.top = navHeight
        collectionView.scrollIndicatorInsets.top = navHeight
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, view.safeAreaLayoutGuide.topAnchor)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // estimated sizing
        let estimatedCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedCell.item = items[indexPath.item]
        estimatedCell.layoutIfNeeded()
        let estimatedSize = estimatedCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
