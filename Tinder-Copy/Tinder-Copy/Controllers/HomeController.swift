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
    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        headerView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let loginController = LoginController()
            loginController.delegate = self
            let navController = UINavigationController(rootViewController: loginController)
            present(navController, animated: true)
        }
    }
    
    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Loading..."
        hud.show(in: view)
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        Firestore.firestore().fetchCurrentUser { (user, error) in
            if let error = error {
                self.hud.dismiss()
                print(error)
                return
            }
            self.currentUser = user
            self.fetchDataFromFirestore()
        }
    }
    
    fileprivate func fetchDataFromFirestore() {
        let query = Firestore.firestore().collection("users")
//            .order(by: "uid")
//            .start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
            .whereField("age", isGreaterThanOrEqualTo: currentUser?.minSeekingAge ?? 18)
            .whereField("age", isLessThanOrEqualTo: currentUser?.maxSeekingAge ?? 100)
        query.getDocuments { (snapshot, error) in
            self.hud.dismiss()
            if let error = error {
                print("failed to fetch data:", error)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView()
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    @objc fileprivate func handleRefresh() {
        fetchDataFromFirestore()
    }
    
    @objc fileprivate func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
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

extension HomeController: SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailController = UserDetailController()
        userDetailController.cardViewModel = cardViewModel
        present(userDetailController, animated: true)
    }
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
}
