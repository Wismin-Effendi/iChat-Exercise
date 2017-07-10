//
//  SignUpViewController.swift
//  iChat
//
//  Created by Hesham Abd-Elmegid on 10/18/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapSignUp(sender: UIButton) {
        guard let name = nameField.text,
            let email = emailField.text,
            let password = passwordField.text,
            name.characters.count > 0,
            email.characters.count > 0,
            password.characters.count > 0
            else {
                self.showAlert(message: "Enter a name, an email and a password.")
                return
        }
        
        func setUser(user: User) {
            self.setUserName(user: user, name: name)
            // Save to Users in Firebase database
            DataService.sharedInstance.saveUser(uid: user.uid, email: email)
        }
        
        AuthService.sharedInstance.signUp(withEmail: email, password: password, sender: self, callback: setUser)
    }

    func setUserName(user: User, name: String) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        
        changeRequest.commitChanges { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            AuthenticationManager.sharedInstance.didLogIn(user: user)
            self.performSegue(withIdentifier: "ShowChatsFromSignUp", sender: nil)
        }
    }
    
    
    
}
