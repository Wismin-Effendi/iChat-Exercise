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
        
        AuthService.sharedInstance.login(withEmail: email, password: password, sender: self)
        
    }
}
