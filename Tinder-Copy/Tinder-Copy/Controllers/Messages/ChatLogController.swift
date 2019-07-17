//
//  ChatLogController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MessagesNavBar(match: self.match)
    fileprivate let navHeight: CGFloat = 120
    fileprivate let match: Match 
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    // input accessory view
    
    lazy var customAccessoryView: CustomAccessoryView = {
        return CustomAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return customAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [
            .init(messageText: "hello", isMessageFromCurrentLoggedUser: true),
            .init(messageText: "isMessageFromCurrentLoggedUserisMessageFromCurrentLoggedUserisMessageFromCurrentLoggedUser", isMessageFromCurrentLoggedUser: false),
            .init(messageText: "QWEQWE", isMessageFromCurrentLoggedUser: true),
            .init(messageText: "this new text", isMessageFromCurrentLoggedUser: true)
        ]
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        collectionView.keyboardDismissMode = .interactive
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
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
