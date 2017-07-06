//
//  Extensions.swift
//  iChat
//
//  Created by Wismin Effendi on 7/6/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "iChat", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
    }
}
