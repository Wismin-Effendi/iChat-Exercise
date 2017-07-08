//
//  DataService.swift
//  iChat
//
//  Created by Wismin Effendi on 7/7/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import Foundation
import FirebaseDatabase


class DataService {
    struct FIR_CHILD {
        static let USERS = "users"
        static let FRIENDS = "friends"
    }
    
    static let sharedInstance = DataService()
    
    var mainRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var usersRef: DatabaseReference {
        return mainRef.child(FIR_CHILD.USERS)
    }
    
    func saveUser(uid: String, email: String) {
        usersRef.child(uid).child("email").setValue(email)
    }
    
    func addFriendToUser(uid: String, friendUID: String, friendEmail: String) {
        let friendsRef = usersRef.child(uid).child(FIR_CHILD.FRIENDS)
        friendsRef.child(friendUID).child("email").setValue(friendEmail)
    }
    
    func removeFriendFromUser(uid: String, friendUID: String) {
        usersRef.child(uid).child(FIR_CHILD.FRIENDS).child(friendUID).removeValue { (error, ref) in
            if error != nil {
                print("Error deleting friend: \(friendUID) from \(uid)")
            }
        }
    }
    
}
