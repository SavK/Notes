//
//  NotesTableViewController+AuthenticationViewControllerDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/10/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

// MARK: - AuthenticationViewControllerDelegate
extension NotesTableViewController: AuthenticationViewControllerDelegate {
    
    func handleTokenChanged(token: String) {
        UserSettings.shared.gitHubToken = token
        loadNotesData()
    }
}
