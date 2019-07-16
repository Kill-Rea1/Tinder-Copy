//
//  KeepSwipingButton.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class KeepSwipingButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.9904103875, green: 0.1256458759, blue: 0.4519847035, alpha: 1)
        let rightColor = #colorLiteral(red: 0.9917781949, green: 0.4024893045, blue: 0.304536581, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: -0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        let cornerRadius = rect.height / 2
        
        // apply a mask using a small rectangle inside the gradient
        let maskLayer = CAShapeLayer()
        let maskPath = CGMutablePath()
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        
        // punch out the middle 
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius).cgPath)
        maskLayer.path = maskPath
        maskLayer.fillRule = .evenOdd
        gradientLayer.mask = maskLayer
        gradientLayer.frame = rect
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
