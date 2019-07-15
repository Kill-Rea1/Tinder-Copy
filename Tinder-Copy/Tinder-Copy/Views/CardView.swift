//
//  CardView.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 12/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    public var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageUrls.first ?? ""
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url)
            }
            informationLabel.attributedText = cardViewModel.attributedText
            informationLabel.textAlignment = cardViewModel.textAligment
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            setupIndexImageObserver()
        }
    }
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    fileprivate let barsStackView = UIStackView()
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel(text: "Information", font: .systemFont(ofSize: 30, weight: .heavy), numberOfLines: 2, textColor: .white)
    fileprivate let threshold: CGFloat = 100
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.constraintWidth(constant: 44)
        button.constraintHeight(constant: 44)
        button.setImage(#imageLiteral(resourceName: "33").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    public var delegate: CardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleMoreInfo() {
//        // hack solution
//        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
//        let userDetailsController = UIViewController()
//        userDetailsController.view.backgroundColor = .yellow
//        rootViewController?.present(userDetailsController, animated: true)
        // delegate solution, more elegant
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    fileprivate func setupIndexImageObserver() {
        cardViewModel.imageIndexObserver = { [weak self] (index, imageUrl) in
            if let url = URL(string: imageUrl ?? "") {
                self?.imageView.sd_setImage(with: url)
            }
            self?.barsStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = self?.barDeselectedColor
            })
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        setupGradientLayer()
        imageView.fillSuperview()
        let stackView = UIStackView(arrangedSubviews: [
            informationLabel, moreInfoButton
            ], customSpacing: 16)
        stackView.alignment = .center
        addSubview(stackView)
        stackView.addConsctraints(leadingAnchor, trailingAnchor, nil, bottomAnchor, .init(top: 0, left: 16, bottom: 16, right: 16))
        setupBarsStackView()
    }
    
    fileprivate func setupBarsStackView() {
        barsStackView.distribution = .fillEqually
        barsStackView.spacing = 4
        addSubview(barsStackView)
        barsStackView.addConsctraints(leadingAnchor, trailingAnchor, topAnchor, nil, .init(top: 8, left: 8, bottom: 0, right: 8), .init(width: 0, height: 4))
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.6, 1.1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: self)
        let shouldAdvance = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvance {
            cardViewModel.advanceNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
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
