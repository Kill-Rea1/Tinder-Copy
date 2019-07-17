//
//  Message.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 17/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let message, fromId, toId: String
    let timestamp: Timestamp
    let isMessageFromCurrentLoggedUser: Bool
    
    init(dictionary: [String: Any]) {
        self.message = dictionary["message"] as! String
        self.fromId = dictionary["fromId"] as! String
        self.toId = dictionary["toId"] as! String
        self.timestamp = dictionary["timestamp"] as! Timestamp
        self.isMessageFromCurrentLoggedUser = Auth.auth().currentUser?.uid == fromId
    }
}
