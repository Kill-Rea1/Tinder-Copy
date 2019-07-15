//
//  CardViewModel.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 12/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    let imageNames: [String]
    let attributedText: NSAttributedString
    let textAligment: NSTextAlignment
    
    init(photos: [String], attributedText: NSAttributedString, textAligment: NSTextAlignment) {
        self.imageNames = photos
        self.attributedText = attributedText
        self.textAligment = textAligment
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageNames[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    // Reactive Programming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func advanceNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
