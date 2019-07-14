//
//  SettingsCell.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 15/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    public let textField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter name"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
