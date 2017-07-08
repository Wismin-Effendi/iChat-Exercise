//
//  UserCell.swift
//  iChat
//
//  Created by Wismin Effendi on 7/7/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(user: ChatUser) {
        emailLabel.text = user.email 
    }

}
