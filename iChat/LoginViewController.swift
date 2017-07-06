//
//  LoginViewController.swift
//  iChat
//
//  Created by Hesham Abd-Elmegid on 10/18/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func didTapLogin(sender: UIButton) {
        guard let email = emailField.text, let password = passwordField.text,
            email.characters.count > 0, password.characters.count > 0 else {
                self.showAlert(message: "Enter an email and a password.")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                switch error._code {
                case AuthErrorCode.userNotFound.rawValue:
                    self.showAlert(message: "User doesn't exist.")
                case AuthErrorCode.wrongPassword.rawValue:
                    self.showAlert(message: "Incorrect username or password.")
                default:
                    self.showAlert(message: "Error: \(error.localizedDescription)")
                }
                print(error.localizedDescription)
                return
            }
            
            if let user = user {
                AuthenticationManager.sharedInstance.didLogIn(user: user)
                self.performSegue(withIdentifier: "ShowChatsFromLogin", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
