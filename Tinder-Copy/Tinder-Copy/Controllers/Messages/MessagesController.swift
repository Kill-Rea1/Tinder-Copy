//
//  MessagesController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools
import Firebase

class MessagesController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {
    
    fileprivate let customNavBar = MatchesNavBar()
    fileprivate let navHeight: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        view.addSubview(customNavBar)
        customNavBar.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, nil, .zero, .init(width: 0, height: navHeight))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        collectionView.contentInset.top = navHeight
        fetchMatches()
    }
    
    fileprivate func fetchMatches() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(uid).collection("matches").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Failed to match matches:", error)
                return
            }
            var matches = [Match]()
            querySnapshot?.documents.forEach({ (documentSnaphot) in
                let dictionary = documentSnaphot.data()
                matches.append(.init(dictionary: dictionary))
            })
            self.items = matches
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = items[indexPath.item]
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 120)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
