//
//  NotesTableViewController+CustomMethods.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/22/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Custom Methods
extension NotesTableViewController {
    
    func toggleEditingMode(forButton button: UIBarButtonItem) {
        if !tableView.isEditing {
            tableView.setEditing(true, animated: true)
            button.title = "Cancel"
            button.tintColor = UIColor.red
        } else {
            tableView.setEditing(false, animated: true)
            button.title = "Edit"
            button.tintColor = view.tintColor
        }
    }
    
    func requestToken() {
        let authenticationViewController = AuthenticationViewController()
        
        authenticationViewController.delegate = self
        present(authenticationViewController, animated: false, completion: nil)
    }
    
    func activityIndicatorStart() {
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func activityIndicatorStop() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
