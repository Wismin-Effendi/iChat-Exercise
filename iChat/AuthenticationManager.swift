//
//  AuthenticationManager.swift
//  iChat
//
//  Created by Wismin Effendi on 7/6/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import Foundation
import Firebase

class AuthenticationManager: NSObject {
    
    static let sharedInstance = AuthenticationManager()
    
    var loggedIn = false
    var userName: String?
    var userId: String?
    
    func didLogIn(user: User) {
        AuthenticationManager.sharedInstance.userName = user.displayName
        AuthenticationManager.sharedInstance.loggedIn = true
        AuthenticationManager.sharedInstance.userId = user.uid
    }
}
