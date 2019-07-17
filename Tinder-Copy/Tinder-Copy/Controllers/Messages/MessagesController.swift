//
//  MessagesController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

//import UIKit
import LBTATools

class MessageCell: LBTAListCell<UIColor> {
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "jane3"), contentMode: .scaleAspectFill)
    let userNameLabel = UILabel(text: "User name", font: .systemFont(ofSize: 14, weight: .semibold), textColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), textAlignment: .center, numberOfLines: 2)
    override func setupViews() {
        super.setupViews()
        
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 40
        stack(stack(profileImageView, alignment: .center),
              userNameLabel)
    }
}

class MessagesController: LBTAListController<MessageCell, UIColor>, UICollectionViewDelegateFlowLayout {
    
    fileprivate let customNavBar = MessagesNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        items = [.black, .black, .black, .black]
        view.addSubview(customNavBar)
        customNavBar.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.safeAreaLayoutGuide.topAnchor, nil, .zero, .init(width: 0, height: 150))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        collectionView.contentInset.top = 150
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 120)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
