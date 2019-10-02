//
//  CustomAccessotyView.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import LBTATools

class CustomAccessoryView: UIView {
    
    public let messageTextView = UITextView()
    public let sendButton = UIButton(title: "Send", titleColor: .black, font: .boldSystemFont(ofSize: 18), target: nil, action: nil)
    public let placeholderLabel = UILabel(text: "Enter Message", font: .systemFont(ofSize: 18), textColor: .lightGray)
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow(opacity: 0.15, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        messageTextView.isScrollEnabled = false
        messageTextView.font = .systemFont(ofSize: 18)
        hstack(messageTextView,
               sendButton.withSize(.init(width: 60, height: 60)),
               alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        addSubview(placeholderLabel)
        placeholderLabel.addConsctraints(leadingAnchor, sendButton.leadingAnchor, nil, nil, .init(top: 0, left: 20, bottom: 0, right: 0))
        placeholderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc fileprivate func handleTextChange() {
        placeholderLabel.isHidden = messageTextView.text.count != 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension CustomAccessoryView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
//        pickerLabel.text = "PickerView Cell Title"
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
}
