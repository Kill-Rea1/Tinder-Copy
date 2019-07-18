//
//  ChatLogController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools
import Firebase

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MessagesNavBar(match: self.match)
    fileprivate let navHeight: CGFloat = 120
    fileprivate let match: Match
    public var currentUser: User!
    fileprivate var listener: ListenerRegistration!
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    // input accessory view
    
    fileprivate lazy var customAccessoryView: CustomAccessoryView = {
        let cav = CustomAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        cav.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return cav
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
        setupViews()
        fetchMessages()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            listener.remove()
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    fileprivate func fetchMessages() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        let query = Firestore.firestore().collection("matches_messages").document(currentUserUid).collection(match.uid).order(by: "timestamp")
        listener = query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Failed to fetch messages:", error)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dictionary = change.document.data()
                    self.items.append(.init(dictionary: dictionary))
                }
            })
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.items.count - 1], at: .bottom, animated: true)
        }
    }
    
    @objc fileprivate func handleSend() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        saveToFromMessages(currentUserUid)
        saveToFromRecentMessages(currentUserUid)
    }
    
    fileprivate func saveToFromRecentMessages(_ currentUserUid: String) {
        let query = Firestore.firestore().collection("matches_messages").document(currentUserUid).collection("recent_messages").document(match.uid)
        let documentData = [
            "name": match.name,
            "profileImageUrl": match.profileImageUrl,
            "uid": match.uid,
            "text": customAccessoryView.messageTextView.text ?? "",
            "timestamp": Timestamp(date: Date())
        ] as [String: Any]
        query.setData(documentData) { (error) in
            if let error = error {
                print("Failed to save recent message:", error)
            }
        }
        
        let anotherQuery = Firestore.firestore().collection("matches_messages").document(match.uid).collection("recent_messages").document(currentUserUid)
        let anotherData = [
            "name": currentUser.name ?? "",
            "profileImageUrl": currentUser.imageUrl1 ?? "",
            "uid": currentUser.uid ?? "",
            "text": customAccessoryView.messageTextView.text ?? "",
            "timestamp": Timestamp(date: Date())
        ] as [String: Any]
        anotherQuery.setData(anotherData) { (error) in
            if let error = error {
                print("Failed to save recent message:", error)
                return
            }
        }
    }
    
    fileprivate func saveToFromMessages(_ currentUserUid: String) {
        let query = Firestore.firestore().collection("matches_messages").document(currentUserUid).collection(match.uid)
        let data = ["message": customAccessoryView.messageTextView.text ?? "",
                    "fromId": currentUserUid,
                    "toId": match.uid,
                    "timestamp": Timestamp(date: Date())
            ] as [String: Any]
        query.addDocument(data: data) { (error) in
            if let error = error {
                print("Failed to save message:", error)
                return
            }
            self.customAccessoryView.messageTextView.text = nil
            self.customAccessoryView.placeholderLabel.isHidden = false
        }
        let otherQuery = Firestore.firestore().collection("matches_messages").document(match.uid).collection(currentUserUid)
        otherQuery.addDocument(data: data) { (error) in
            if let error = error {
                print("Failed to save message:", error)
                return
            }
            self.customAccessoryView.messageTextView.text = nil
            self.customAccessoryView.placeholderLabel.isHidden = false
        }
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        collectionView.scrollToItem(at: [0, items.count - 1], at: .bottom, animated: true)
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
