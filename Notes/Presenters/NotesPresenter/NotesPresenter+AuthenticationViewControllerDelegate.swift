//
//  NotesPresenter+AuthenticationViewControllerDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

//// MARK: - AuthenticationViewControllerDelegate
extension NotesPresenter: AuthenticationViewControllerDelegate {
    
    func handleTokenChanged(token: String) {
        UserSettings.shared.gitHubToken = token
        loadNotesData()
    }
}
