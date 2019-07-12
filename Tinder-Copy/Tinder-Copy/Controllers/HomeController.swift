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
    fileprivate let cardsView = UIView()
    fileprivate let bottomView = BottomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupDummyCards()
    }
    
    fileprivate func setupDummyCards() {
        let cardView = CardView()
        cardsView.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    fileprivate func setupStackView() {
        let stackView = VerticalStackView(arrangedSubviews: [
            headerView, cardsView, bottomView
            ])
        stackView.bringSubviewToFront(cardsView)
        view.addSubview(stackView)
        stackView.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, view.safeAreaLayoutGuide.bottomAnchor, .init(top: 0, left: 12, bottom: 0, right: 12))
    }
}

