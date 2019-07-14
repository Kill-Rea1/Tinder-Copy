//
//  ViewController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 12/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HomeController: UIViewController {
    
    fileprivate let headerView = HeaderView()
    fileprivate let cardsDeckView = UIView()
    fileprivate let bottomView = BottomView()
    fileprivate var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupDummyCards()
        headerView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        fetchDataFromFirestore()
    }
    
    fileprivate func fetchDataFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("failed to fetch data:", error)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
            })
            self.setupDummyCards()
        }
    }
    
    @objc fileprivate func handleSettings() {
        
    }
    
    fileprivate func setupDummyCards() {
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView()
            cardView.cardViewModel = cardViewModel
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupStackView() {
        view.backgroundColor = .white
        let stackView = VerticalStackView(arrangedSubviews: [
            headerView, cardsDeckView, bottomView
            ])
        stackView.bringSubviewToFront(cardsDeckView)
        view.addSubview(stackView)
        stackView.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, view.safeAreaLayoutGuide.bottomAnchor, .init(top: 0, left: 12, bottom: 0, right: 12))
    }
}

