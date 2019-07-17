//
//  ChatLogController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools

struct Message {
    let textMessage: String
}

class MessageCell: LBTAListCell<Message> {
    override var item: Message! {
        didSet {
            backgroundColor = .black
        }
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
        
        collectionView.backgroundColor = .white
        view.addSubview(customNavBar)
        customNavBar.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, nil, .zero, .init(width: 0, height: navHeight))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        collectionView.contentInset.top = navHeight
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
