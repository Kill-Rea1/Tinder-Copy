//
//  ViewController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 12/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    fileprivate let headerView = HeaderView()
    fileprivate let cardsDeckView = UIView()
    fileprivate let bottomView = BottomView()
    
    let cardViewModels = [
        User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "lady5c").toCardViewModel(),
        User(name: "Jane", age: 18, profession: "Teacher", imageName: "lady4c").toCardViewModel()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStackView()
        setupDummyCards()
        (bottomView.subviews[0] as! UIButton).addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    }
    
    @objc fileprivate func handleRefresh() {
        setupDummyCards()
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
        let stackView = VerticalStackView(arrangedSubviews: [
            headerView, cardsDeckView, bottomView
            ])
        stackView.bringSubviewToFront(cardsDeckView)
        view.addSubview(stackView)
        stackView.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, view.safeAreaLayoutGuide.bottomAnchor, .init(top: 0, left: 12, bottom: 0, right: 12))
    }
}

