//
//  MessagesController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools
import Firebase

class RecentMessageCell: LBTAListCell<UIColor> {
    
    let userProfileImageView = CircularImageView(width: 94, image: #imageLiteral(resourceName: "kelly1"))
    let usernameLabel = UILabel(text: "Name", font: .boldSystemFont(ofSize: 18))
    let messageTextLabel = UILabel(text: "Text", font: .systemFont(ofSize: 16), numberOfLines: 2)
    
    override var item: UIColor! {
        didSet {
            backgroundColor = .white
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

class MatchesController: LBTAListHeaderController<RecentMessageCell, UIColor, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    
    fileprivate let customNavBar = MatchesNavBar()
    fileprivate let navHeight: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        items = [.black, .red, .blue, .green, .purple, .yellow]
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
    
//    fileprivate func fetchMatches() {
//        Firestore.firestore().fetchMatches { (matches, error) in
//            if let error = error {
//                print("Failed to match matches:", error)
//                return
//            }
//            guard let matches = matches else { return }
//            self.items = matches
//            self.collectionView.reloadData()
//        }
//    }
    
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
