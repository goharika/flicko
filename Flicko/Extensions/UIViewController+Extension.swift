//
//  UIViewController+Extension.swift
//  Flicko
//
//  Created by Gohar on 10/11/2018.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

