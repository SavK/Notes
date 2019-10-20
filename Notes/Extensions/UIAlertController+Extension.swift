//
//  UIAlertController+Extension.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/20/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func showAlert(withTitle title: String,
                         message: String,
                         actions:[UIAlertAction],
                         target: UIViewController) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        actions.forEach { alert.addAction($0) }
        target.present(alert, animated: true, completion: nil)
    }
}
