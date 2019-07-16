//
//  MatchView.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 16/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class MatchView: UIView {
    fileprivate let size: CGFloat = 140
    fileprivate let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    fileprivate let currentUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        return iv
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jane3"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        setupBlurView()
        setupLayout()
    }
    
    fileprivate func setupBlurView() {
        blurEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        addSubview(blurEffect)
        blurEffect.fillSuperview()
        performAnimation(alpha: 1)
    }
    
    fileprivate func setupLayout() {
        addSubview(currentUserImageView)
        addSubview(cardUserImageView)
        cardUserImageView.layer.cornerRadius = size / 2
        currentUserImageView.layer.cornerRadius = size / 2
        currentUserImageView.addConsctraints(nil, centerXAnchor, nil, nil, .init(top: 0, left: 0, bottom: 0, right: 16), .init(width: size, height: size))
        cardUserImageView.addConsctraints(centerXAnchor, nil, nil, nil, .init(top: 0, left: 16, bottom: 0, right: 0), .init(width: size, height: size))
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc fileprivate func handleTap() {
        performAnimation(alpha: 0, isRemoving: true)
    }
    
    fileprivate func performAnimation(alpha: CGFloat, isRemoving: Bool = false) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = alpha
        }) { (_) in
            if isRemoving {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
