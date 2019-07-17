//
//  MessagesController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

//import UIKit
import LBTATools

class MessagesController: UICollectionViewController {
    
    let customNavBar: UIView = {
        let view = UIView(backgroundColor: .white)
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        iconImageView.tintColor = #colorLiteral(red: 1, green: 0.4412513971, blue: 0.4679982662, alpha: 1)
        let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 22), textColor: #colorLiteral(red: 1, green: 0.4412513971, blue: 0.4679982662, alpha: 1), textAlignment: .center)
        let feedLabel = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 22), textColor: .gray, textAlignment: .center)
        view.setupShadow(opacity: 0.35, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        view.stack(iconImageView.withHeight(40),
                   view.hstack(messagesLabel, feedLabel, distribution: .fillEqually)).padTop(16)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        view.addSubview(customNavBar)
        customNavBar.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, nil, .zero, .init(width: 0, height: 150))
    }
}
