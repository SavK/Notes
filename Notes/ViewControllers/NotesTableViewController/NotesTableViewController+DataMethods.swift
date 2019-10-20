//
//  NotesTableViewController+DataMethods.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/10/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation
import CocoaLumberjack

// MARK: - Data Methods
extension NotesTableViewController {
    
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
            UIAlertController.showAlert(withTitle: "You are not logged in GitHub",
                                        message:
                "Sorry, but you are not logged in. Would you like to log into your GitHub account now?",
                                        actions: [yesAction, noAction], target: self)
        }
        
        OperationQueue.main.addOperation {
            self.deleteNoteActivityIndicatorStart()
        }
        
        loadNotes.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            let loadedNotes = loadNotes.result ?? []
            DDLogDebug(" \(loadedNotes.count) notes was uploaded")
            self.notes = loadedNotes
            OperationQueue.main.addOperation {
                self.deleteNoteActivityIndicatorStop()
                self.tableView.reloadData()
                self.isNeedEditNotes()
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
            self.deleteNoteActivityIndicatorStart()
        }
        ///Delete row with animation
        removeNote.completionBlock = {
            DDLogDebug("Removed tableViewCell at row: \(indexPath.row)")
            OperationQueue.main.addOperation {
                UIView.animate(withDuration: 0.5) {
                    self.deleteNoteActivityIndicatorStop()
                    self.notes.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                    self.isNeedEditNotes()
                }
            }
        }
        OperationQueue().addOperation(removeNote)
    }
}
