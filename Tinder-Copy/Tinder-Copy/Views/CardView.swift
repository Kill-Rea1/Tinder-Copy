//
//  CardView.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 12/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class CardView: UIView {
    public var cardViewModel: CardViewModel! {
        didSet {
            imageView.image = UIImage(named: cardViewModel.imageName)
            informationLabel.attributedText = cardViewModel.attributedText
            informationLabel.textAlignment = cardViewModel.textAligment
        }
    }
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    fileprivate let informationLabel = UILabel(text: "Information", font: .systemFont(ofSize: 30, weight: .heavy), numberOfLines: 2, textColor: .white)
    fileprivate let threshold: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(imageView)
        imageView.fillSuperview()
        addSubview(informationLabel)
        informationLabel.addConsctraints(leadingAnchor, trailingAnchor, nil, bottomAnchor, .init(top: 0, left: 16, bottom: 16, right: 16))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            return
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        transform = CGAffineTransform(rotationAngle: angle).translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let isShouldDismiss = abs(gesture.translation(in: self).x) > threshold
        let direction: CGFloat = gesture.translation(in: self).x > 0 ? 1 : -1
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if isShouldDismiss {
                self.frame = CGRect(x: 600 * direction, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
        }, completion: { (_) in
            if isShouldDismiss {
                self.removeFromSuperview()
            }
            self.transform = .identity
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
