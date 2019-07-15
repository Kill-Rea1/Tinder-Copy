//
//  AgeRangeCell.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 15/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    
    fileprivate let padding: CGFloat = 16
    
    let minLabel: AgeRangeLabel = {
        let label = AgeRangeLabel()
        label.text = "min"
        return label
    }()
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxLabel: AgeRangeLabel = {
        let label = AgeRangeLabel()
        label.text = "max"
        return label
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let overallStackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minSlider], customSpacing: padding),
            UIStackView(arrangedSubviews: [maxLabel, maxSlider], customSpacing: padding)
            ], spacing: padding)
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
