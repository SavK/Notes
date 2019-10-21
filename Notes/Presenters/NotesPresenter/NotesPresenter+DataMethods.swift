//
//  NotesPresenter+DataMethods.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CocoaLumberjack

// MARK: - Data Methods
extension NotesPresenter {
    
    func loadNotesData() {
        let loadNotes = LoadNotesOperation(notebook: FileNotebook.notebook,
                                           backendQueue: backendOperationQueue,
                                           dbQueue: dbOperationQueue,
                                           backgroundContext: backgroundContext)
        
        let userSettings = UserSettings.shared
        
        if userSettings.isNeedAuthorization,
            !userSettings.isLoginedInGitHub,
            userSettings.isInternetConnectionOn {
            
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                UserSettings.shared.isNeedAuthorization = false
                self.requestToken()
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
                                        target: viewController)
        }
        
        OperationQueue.main.addOperation {
            self.viewController.deleteNoteActivityIndicatorStart()
        }
        
        loadNotes.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            let loadedNotes = loadNotes.result ?? []
            DDLogDebug(" \(loadedNotes.count) notes was uploaded")
            self.notes = loadedNotes
            let isNeedEditing = self.notes.count > 0
            OperationQueue.main.addOperation {
                self.viewController.deleteNoteActivityIndicatorStop()
                self.viewController.tableView.reloadData()
                self.viewController.isNeedEditNotes(isNeedEditing)
            }
        }
        OperationQueue().addOperation(loadNotes)
    }
    
    
    func removeNoteData(at indexPath: IndexPath) {
        let deletedNote = notes[indexPath.row]
        let removeNote = RemoveNoteOperation(note: deletedNote,
                                             notebook: noteBook,
                                             backendQueue: backendOperationQueue,
                                             dbQueue: dbOperationQueue,
                                             backgroundContext: backgroundContext)
        
        OperationQueue.main.addOperation {
            self.viewController.deleteNoteActivityIndicatorStart()
        }
        ///Delete row with animation
        removeNote.completionBlock = {
            DDLogDebug("Removed tableViewCell at row: \(indexPath.row)")
            OperationQueue.main.addOperation {
                UIView.animate(withDuration: 0.5) {
                    self.viewController.deleteNoteActivityIndicatorStop()
                    self.notes.remove(at: indexPath.row)
                    self.viewController.tableView.deleteRows(at: [indexPath], with: .left)
                    
                    let isNeedEditing = self.notes.count > 0
                    self.viewController.isNeedEditNotes(isNeedEditing)
                }
            }
        }
        OperationQueue().addOperation(removeNote)
    }
}
