//
//  MatchView.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 16/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class MatchView: UIView {
    
    public var currentUser: User!
    
    public var cardUID: String! {
        didSet {
            let query = Firestore.firestore().collection("users")
            query.document(cardUID).getDocument { (snapshot, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let dictionary = snapshot?.data() else { return }
                let user = User(dictionary: dictionary)
                guard let cardUserUrl = URL(string: user.imageUrl1 ?? "") else { return }
                self.desciptionLabel.text = "You and \(user.name ?? "") have liked\neach other"
                self.cardUserImageView.sd_setImage(with: cardUserUrl)
                guard let currentUserUrl = URL(string: self.currentUser.imageUrl1 ?? "") else { return }
                self.currentUserImageView.sd_setImage(with: currentUserUrl, completed: { (_, _, _, _) in
                    self.setupAnimations()
                })
            }
        }
    }
    
    fileprivate let size: CGFloat = 140
    fileprivate let buttonHeight: CGFloat = 64
    fileprivate let padding: CGFloat = 32
    fileprivate let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    fileprivate let itsAMatchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    fileprivate let desciptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    fileprivate lazy var currentUserImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.constraintWidth(constant: size)
        iv.constraintHeight(constant: size)
        iv.layer.cornerRadius = size / 2
        iv.layer.borderWidth = 2
        iv.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        return iv
    }()
    
    fileprivate lazy var cardUserImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.constraintWidth(constant: size)
        iv.constraintHeight(constant: size)
        iv.layer.cornerRadius = size / 2
        iv.layer.borderWidth = 2
        iv.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        iv.alpha = 0
        return iv
    }()
    
    fileprivate lazy var sendMessageButton: SendMessageButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.constraintHeight(constant: buttonHeight)
        return button
    }()
    
    fileprivate lazy var keepSwipingButton: KeepSwipingButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.constraintHeight(constant: buttonHeight)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var views = [
        itsAMatchImageView,
        desciptionLabel,
        currentUserImageView,
        cardUserImageView,
        sendMessageButton,
        keepSwipingButton
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        setupBlurView()
        setupLayout()
    }
    
    fileprivate func setupAnimations() {
        // starting positions
        let angle = 30 * CGFloat.pi / 180
        let imageStartPositionX: CGFloat = 200
        let buttonStartPositionX: CGFloat = 500
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: imageStartPositionX, y: 0))
        cardUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -imageStartPositionX, y: 0))
        sendMessageButton.transform = CGAffineTransform(translationX: -buttonStartPositionX, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: buttonStartPositionX, y: 0)
        
        // keyframe animations for segmented animations
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            // animation 1 - translation back to original position
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                self.views.forEach({$0.alpha = 1})
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            })
            
            // animation 2 - rotation
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
            })
        })
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        })
    }
    
    fileprivate func setupBlurView() {
        blurEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        addSubview(blurEffect)
        blurEffect.fillSuperview()
        performAnimation(alpha: 1)
    }
    
    fileprivate func setupLayout() {
        views.forEach({$0.alpha = 0})
        let imageStackView = UIStackView(arrangedSubviews: [
            currentUserImageView, cardUserImageView
            ], customSpacing: padding)
        imageStackView.distribution = .fillEqually
        let buttonStackView = VerticalStackView(arrangedSubviews: [sendMessageButton, keepSwipingButton], spacing: padding / 2)
        let verticalStackView = VerticalStackView(arrangedSubviews: [
            itsAMatchImageView, desciptionLabel, imageStackView, buttonStackView
            ], spacing: padding)
        addSubview(verticalStackView)
        let width = size * 2 + padding
        verticalStackView.centerInSuperview(size: .init(width: width, height: 0))
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
