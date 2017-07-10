//
//  AuthService.swift
//  iChat
//
//  Created by Wismin Effendi on 7/10/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import Firebase

class AuthService {
    
    static let sharedInstance = AuthService()
    
    func login(withEmail email: String, password: String, sender: UIViewController) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                switch error._code {
                case AuthErrorCode.userNotFound.rawValue:
                    sender.showAlert(message: "User doesn't exist.")
                case AuthErrorCode.wrongPassword.rawValue:
                    sender.showAlert(message: "Incorrect username or password.")
                default:
                    sender.showAlert(message: "Error: \(error.localizedDescription)")
                }
                print(error.localizedDescription)
                return
            }
            
            if let user = user {
                
                AuthenticationManager.sharedInstance.didLogIn(user: user)
                sender.performSegue(withIdentifier: "ShowChatsFromLogin", sender: nil)
            }
        }
    }
    
    func signUp(withEmail email: String, password: String, sender: UIViewController, callback: @escaping (User) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                if error._code == AuthErrorCode.invalidEmail.rawValue {
                    sender.showAlert(message: "Enter a valid email.")
                } else if error._code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    sender.showAlert(message: "Email already in use.")
                } else {
                    sender.showAlert(message: "Error: \(error.localizedDescription)")
                }
                print(error.localizedDescription)
                return
            }
            
            callback(user!)
        }
        
    }
}
