//
//  MessagesController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools
import Firebase

struct RecentMessage {
    let name, text, profileImageUrl, uid: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}

class RecentMessageCell: LBTAListCell<RecentMessage> {
    
    let userProfileImageView = CircularImageView(width: 94, image: #imageLiteral(resourceName: "kelly1"))
    let usernameLabel = UILabel(text: "Name", font: .boldSystemFont(ofSize: 18))
    let messageTextLabel = UILabel(text: "Text", font: .systemFont(ofSize: 16), numberOfLines: 2)
    
    override var item: RecentMessage! {
        didSet {
            userProfileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
            usernameLabel.text = item.name
            messageTextLabel.text = item.text
        }
    }
    
    override func setupViews() {
        super.setupViews()
        hstack(
            userProfileImageView,
            stack(
                usernameLabel,
                messageTextLabel,
                spacing: 4
            ),
            spacing: 20,
            alignment: .center
        ).padLeft(20).padRight(20)
        addSeparatorView(leadingAnchor: usernameLabel.leadingAnchor)
    }
}

class MatchesController: LBTAListHeaderController<RecentMessageCell, RecentMessage, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    
    fileprivate let customNavBar = MatchesNavBar()
    fileprivate let navHeight: CGFloat = 150
    fileprivate var recentMessagesDictionary = [String: RecentMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchRecentMessages()
    }
    
    fileprivate func fetchRecentMessages() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        let query = Firestore.firestore().collection("matches_messages").document(currentUserUid).collection("recent_messages")
        query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Failed to fetch resent messages:", error)
            }
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added || change.type == .modified {
                    let dictionary = change.document.data()
                    let recentMessage = RecentMessage(dictionary: dictionary)
                    self.recentMessagesDictionary[recentMessage.uid] = recentMessage
                }
            })
            self.resetItems()
        }
    }
    
    fileprivate func resetItems() {
        let values = Array(recentMessagesDictionary.values)
        items = values.sorted(by: { (rm1, rm2) -> Bool in
            return rm1.timestamp.compare(rm2.timestamp) == .orderedDescending
        })
        collectionView.reloadData()
    }
    
    override func setupHeader(_ header: MatchesHeader) {
        header.matchesHorizontalController.rootMatchesController = self
    }
    
    func didSelectMatchFromHeader(match: Match) {
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = navHeight
        collectionView.scrollIndicatorInsets.top = navHeight
        view.addSubview(customNavBar)
        customNavBar.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, nil, .zero, .init(width: 0, height: navHeight))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, view.safeAreaLayoutGuide.topAnchor)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentMessage = items[indexPath.item]
        let dictionary = [
            "name": recentMessage.name,
            "profileImageUrl": recentMessage.profileImageUrl,
            "uid": recentMessage.uid
        ]
        let match = Match(dictionary: dictionary)
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
