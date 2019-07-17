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
    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var currentUser: User?
    fileprivate var topCardView: CardView?
    fileprivate var swipes = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupStackView()
        headerView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        headerView.messageButton.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        bottomView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomView.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
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
            self.fetchSwipes()
        }
    }
    
    fileprivate func fetchSwipes() {
//        swipes = [:]
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = snapshot?.data() as? [String: Int] else {
                self.fetchDataFromFirestore()
                return
            }
            self.swipes = data
            self.fetchDataFromFirestore()
        }
    }
    
    fileprivate func fetchDataFromFirestore() {
        let minAge = currentUser?.minSeekingAge ?? User.defaultMinSeekingAge
        let maxAge = currentUser?.maxSeekingAge ?? User.defaultMaxSeekingAge
        topCardView = nil
        let query = Firestore.firestore().collection("users")
//            .order(by: "uid")
//            .start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
            .whereField("age", isGreaterThanOrEqualTo: minAge)
            .whereField("age", isLessThanOrEqualTo: maxAge)
        query.getDocuments { (snapshot, error) in
            self.hud.dismiss()
            if let error = error {
                print("failed to fetch data:", error)
                return
            }
            // Linked List
            var previousCardView: CardView?
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
//                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                let hasNotSwipedBefore = true
                if isNotCurrentUser && hasNotSwipedBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView()
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    @objc fileprivate func handleRefresh() {
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        fetchSwipes()
    }
    
    @objc fileprivate func handleMessages() {
        let messagesController = MessagesController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(messagesController, animated: true)
    }
    
    @objc fileprivate func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = currentUser
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    fileprivate func checkIfMatchExist(cardUID: String) {
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = snapshot?.data() else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let hasMatch = data[uid] as? Int == 1
            if hasMatch {
                self.presentMatchView(cardUID: cardUID)
            }
        }
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        let documentData = [cardUID: didLike]
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    if didLike == 1 {
                        self.checkIfMatchExist(cardUID: cardUID)
                    }
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    if didLike == 1 {
                        self.checkIfMatchExist(cardUID: cardUID)
                    }
                }
            }
        }
    }
    
    @objc fileprivate func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(duration: 0.5, translation: 700, angle: 20)
    }
    
    @objc fileprivate func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(duration: 0.75, translation: -700, angle: -15)
    }
    
    fileprivate func performSwipeAnimation(duration: Double, translation: CGFloat, angle: CGFloat) {
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        let cardView = topCardView
        topCardView = topCardView?.nextCardView
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
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
    func didSwipedOut(didLike: Bool) {
        if didLike {
            handleLike()
        } else {
            handleDislike()
        }
    }
    
    func didRemoveCardView(cardView: CardView) {
        topCardView?.removeFromSuperview()
        topCardView = topCardView?.nextCardView
    }
    
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
