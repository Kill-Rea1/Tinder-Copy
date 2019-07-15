//
//  UserDetailController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 16/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class UserDetailController: UIViewController {
    
    fileprivate lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    fileprivate let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    fileprivate let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Name 30\nDoctor\nSome Bio"
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        scrollView.addSubview(infoLabel)
        infoLabel.addConsctraints(scrollView.leadingAnchor, scrollView.trailingAnchor, imageView.bottomAnchor, nil, .init(top: 16, left: 16, bottom: 0, right: 16))
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap() {
        dismiss(animated: true)
    }
}

extension UserDetailController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = scrollView.contentOffset.y
        let width = view.frame.width - changeY * 2
        if changeY < 0 {
            imageView.frame = CGRect(x: changeY, y: changeY, width: width, height: width)
        }
    }
}
