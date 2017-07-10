//
//  ChatViewController.swift
//  iChat
//
//  Created by Hesham Abd-Elmegid on 10/18/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var outgoingMessageBubbleImage: JSQMessagesBubbleImage!
    var incomingMessageBubbleImage: JSQMessagesBubbleImage!
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    var friendsUID = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        senderId = AuthenticationManager.sharedInstance.userId
        senderDisplayName = AuthenticationManager.sharedInstance.userName
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        setupMessageBubbles()
        
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messages.removeAll()
        getUserOwnMessages()
        getListOfFriendsMessages()
    
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ref.removeObserver(withHandle: databaseHandle)
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let messageRef = ref.child("messages").childByAutoId()
        let message = [
            "text": text,
            "senderId": senderId,
            "senderDisplayName": senderDisplayName
        ]
        messageRef.setValue(message)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            AuthenticationManager.sharedInstance.loggedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    
    // MARK: Added for Task in Exercise 4.8 
    
    private func getUserOwnMessages() {
        databaseHandle = ref.child("messages").queryOrdered(byChild:"senderId").queryEqual(toValue: senderId).observe(.value, with: addToMessageFromSnapshot)
    }
    
    private func getListOfFriendsMessages() {
        DataService.sharedInstance.usersRef.child(senderId).child(DataService.FIR_CHILD.FRIENDS)
            .observe(.childAdded, with: {[unowned self] (snapshot) in
        
                if let chatUser = ChatUser.create(from: snapshot) {
                    let friendUID = chatUser.uid
                    self.databaseHandle = self.ref.child("messages").queryOrdered(byChild:"senderId").queryEqual(toValue: friendUID).observe(.value, with: self.addToMessageFromSnapshot)
                }
            })
    }
    
    private func addToMessageFromSnapshot(snapshot: DataSnapshot) {
        print(snapshot)
        if let value = (snapshot.value as? [String:AnyObject])?.values.first {
            print(value)
            let id = value["senderId"] as! String
            let text = value["text"] as! String
            let name = value["senderDisplayName"] as! String
            
            self.addMessage(id: id, text: text, name: name)
            self.finishReceivingMessage()
        }
    }
    

    // MARK: Helper
    
    private func setupMessageBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingMessageBubbleImage = factory?.outgoingMessagesBubbleImage(with: UIColor(red: 0.97, green: 0.57, blue: 0.01, alpha: 1.00))
        incomingMessageBubbleImage = factory?.incomingMessagesBubbleImage(with: .jsq_messageBubbleLightGray())
    }
    
    func addMessage(id: String, text: String, name: String) {
        let message = JSQMessage(senderId: id, displayName: name, text: text)
        messages.append(message!)
    }
    
    // MARK: CollectionViewDataSource and Delegate 
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingMessageBubbleImage
        } else {
            return incomingMessageBubbleImage
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = .white
        } else {
            cell.textView!.textColor = .black
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.item]
        switch message.senderId {
            // Here we are displaying everyone's name above their message except for the "Senders"
        case senderId:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        return 20.0
    }
}
