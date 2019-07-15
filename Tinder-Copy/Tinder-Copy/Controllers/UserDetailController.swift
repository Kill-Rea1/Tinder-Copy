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
    
    fileprivate let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "34").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return button
    }()
    
    public var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedText
            guard let imageUrl = cardViewModel.imageUrls.first, let url = URL(string: imageUrl) else { return }
            imageView.sd_setImage(with: url)
        }
    }
    fileprivate lazy var dislikeButton = self.createButton(image: #imageLiteral(resourceName: "3 2"), selector: #selector(handleDislike))
    fileprivate lazy var superLikeButton = self.createButton(image: #imageLiteral(resourceName: "3 3"), selector: #selector(handleDislike))
    fileprivate lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "3 4"), selector: #selector(handleDislike))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupVisualBlurEffectView()
        setupBottomButtons()
        view.backgroundColor = .white
    }
    
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    @objc fileprivate func handleDislike() {}
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        scrollView.addSubview(infoLabel)
        infoLabel.addConsctraints(scrollView.leadingAnchor, scrollView.trailingAnchor, imageView.bottomAnchor, nil, .init(top: 16, left: 16, bottom: 0, right: 16))
        scrollView.addSubview(dismissButton)
        dismissButton.addConsctraints(nil, view.trailingAnchor, imageView.bottomAnchor, nil, .init(top: -25, left: 0, bottom: 0, right: 24), .init(width: 50, height: 50))
    }
    
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, view.safeAreaLayoutGuide.topAnchor)
    }
    
    fileprivate func setupBottomButtons() {
        let stackView = UIStackView(arrangedSubviews: [
            dislikeButton, superLikeButton, likeButton
            ], customSpacing: -32)
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.addConsctraints(nil, nil, nil, view.safeAreaLayoutGuide.bottomAnchor, .init(top: 0, left: 0, bottom: 0, right: 0), .init(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
