//
//  ChooseFriendsViewController.swift
//  iChat
//
//  Created by Wismin Effendi on 7/7/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChooseFriendsViewController: UITableViewController {

    private var chatUsers = [ChatUser]()
    private var selectedChatUsers = [ChatUser]()

    private var userId = AuthenticationManager.sharedInstance.userId!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Choose Friends"
        
        navigationItem.backBarButtonItem?.title = "Friends"
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        DataService.sharedInstance.usersRef
            .observe(.childAdded, with: {[unowned self] (snapshot) in
                
                if let chatUser = self.createChatUser(from: snapshot) {
                    self.chatUsers.append(chatUser)
                }
                
                DataService.sharedInstance.usersRef.child(self.userId).child(DataService.FIR_CHILD.FRIENDS)
                    .observe(.childAdded, with: {[unowned self] (snapshot2) in
                        
                        if let chatUser = self.createChatUser(from: snapshot2) {
                            self.selectedChatUsers.append(chatUser)
                        }
                    })
                self.tableView.reloadData()
            })

    }

    private func createChatUser(from snapshot: DataSnapshot) -> ChatUser? {
        let uid = snapshot.key
        guard self.userId != uid else {
            // skip if it's same user
            return nil
        }
        if let value = snapshot.value as? [String:AnyObject],
            let email = value["email"] as? String {
            let chatUser = ChatUser(uid: uid, email: email)
            return chatUser
        }
        return nil
    }

    @IBAction func chatTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: SegueIdentifier.chatVC, sender: self)
    }
    

    // MARK: - Table view data source

    // Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let chatUser = chatUsers[indexPath.row]
        cell.updateUI(user: chatUser)
        
        let isFriend = selectedChatUsers.contains(chatUser)
        cell.accessoryType = isFriend ? .checkmark : .none
        
        return cell
    }
    
    // Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatUser = chatUsers[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = (cell.accessoryType == .none) ? .checkmark : .none
        if cell.accessoryType == .checkmark {
            selectedChatUsers.append(chatUser)
            DataService.sharedInstance.addFriendToUser(uid: userId, friendUID: chatUser.uid, friendEmail: chatUser.email)
        } else {
            // remove this chatUser
            selectedChatUsers = selectedChatUsers.filter { $0 != chatUser }
            DataService.sharedInstance.removeFriendFromUser(uid: userId, friendUID: chatUser.uid)
            
        }
        
    }


}
