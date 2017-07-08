//
//  ChatUser.swift
//  iChat
//
//  Created by Wismin Effendi on 7/7/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit

struct ChatUser {
    
    var uid: String
    var email: String
}

extension ChatUser: Equatable {
    static func == (lhs: ChatUser, rhs: ChatUser) -> Bool {
        return lhs.uid == rhs.uid
    }
}
