//
//  StartViewController.swift
//  iChat
//
//  Created by Wismin Effendi on 7/10/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let user = Auth.auth().currentUser {
            
            AuthenticationManager.sharedInstance.didLogIn(user: user)
            performSegue(withIdentifier: "SkipLogin", sender: nil)
        }
    }

    
}
