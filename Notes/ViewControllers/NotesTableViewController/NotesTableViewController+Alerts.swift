//
//  NotesTableViewController+Alerts.swift
//  Notes
//
//  Created by Savonevich Constantine on 11/4/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

extension NotesTableViewController {
    
    func showAuthorizationAlert() {
        let userSettings = UserSettings.shared
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            UserSettings.shared.isNeedAuthorization = false
            self?.requestToken()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            userSettings.isNeedAuthorization = false
        }
        
        let message =
        """
        Sorry, but you are not logged in.
        Would you like to log into your GitHub account now?
        """
        
        UIAlertController.showAlert(withTitle: "You are not logged in GitHub",
                                    message: message,
                                    actions: [yesAction, noAction],
                                    target: self)
    }
    
    func showErrorAlert(withTitle title: String) {
        UIAlertController.showErrorAlert(withTitle: title,
                                         target: self)
    }
}
