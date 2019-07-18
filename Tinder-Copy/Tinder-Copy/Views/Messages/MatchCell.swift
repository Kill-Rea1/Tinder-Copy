//
//  MatchCell.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools

class MatchCell: LBTAListCell<Match> {
    
    fileprivate let imageSize: CGFloat = 94
    
    public override var item: Match! {
        didSet {
            userNameLabel.text = item.name
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    fileprivate let profileImageView = UIImageView(image: #imageLiteral(resourceName: "jane3"), contentMode: .scaleAspectFill)
    fileprivate let userNameLabel = UILabel(text: "User name", font: .systemFont(ofSize: 14, weight: .semibold), textColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), textAlignment: .center, numberOfLines: 2)
    override func setupViews() {
        super.setupViews()
        
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(imageSize)
        profileImageView.constrainHeight(imageSize)
        profileImageView.layer.cornerRadius = imageSize / 2
        stack(stack(profileImageView, alignment: .center),
              userNameLabel)
    }
}
