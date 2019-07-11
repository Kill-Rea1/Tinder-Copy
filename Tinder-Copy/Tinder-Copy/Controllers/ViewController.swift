//
//  ViewController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 12/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate let headerView = HeaderView()
    fileprivate let bottomView = BottomView()
    fileprivate let middleView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        middleView.backgroundColor = .blue
        setupStackView()
    }
    
    fileprivate func setupStackView() {
        let stackView = VerticalStackView(arrangedSubviews: [
            headerView, middleView, bottomView
            ])
        view.addSubview(stackView)
        stackView.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, view.safeAreaLayoutGuide.bottomAnchor)
    }
}

