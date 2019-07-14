//
//  ViewController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 12/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    fileprivate let headerView = HeaderView()
    fileprivate let cardsDeckView = UIView()
    fileprivate let bottomView = BottomView()
    fileprivate var cardViewModels = [CardViewModel]()
    fileprivate var lastFetchedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
//        setupFirestoreUserCards()
        headerView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        fetchDataFromFirestore()
    }
    
    fileprivate func fetchDataFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { (snapshot, error) in
            hud.dismiss()
            if let error = error {
                print("failed to fetch data:", error)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
            })
//            self.setupFirestoreUserCards()
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView()
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    @objc fileprivate func handleRefresh() {
        fetchDataFromFirestore()
    }
    
    @objc fileprivate func handleSettings() {
        
    }
    
    fileprivate func setupFirestoreUserCards() {
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

