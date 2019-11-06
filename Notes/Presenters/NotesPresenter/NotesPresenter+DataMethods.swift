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
        let loadNotes = LoadNotesOperation(notebook: noteBook,
                                           backendQueue: backendOperationQueue,
                                           dbQueue: dbOperationQueue,
                                           backgroundContext: backgroundContext)
        
        let userSettings = UserSettings.shared
        
        if userSettings.isNeedAuthorization,
            !userSettings.isLoginedInGitHub,
            userSettings.isInternetConnectionOn {
            viewController.showAuthorizationAlert()
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
                self.viewController.reloadTableViewData()
                self.viewController.isNeedEditNotes(isNeedEditing)
            }
        }
        OperationQueue().addOperation(loadNotes)
    }
    
    
    func removeNoteData(atIndex index: Int) {
        let deletedNote = notes[index]
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
            DDLogDebug("Removed tableViewCell at row: \(index)")
            OperationQueue.main.addOperation {
                UIView.animate(withDuration: 0.5) {
                    self.viewController.deleteNoteActivityIndicatorStop()
                    self.notes.remove(at: index)
                    self.viewController.deleteTableViewRow(atIndex: index)
                    
                    let isNeedEditing = self.notes.count > 0
                    self.viewController.isNeedEditNotes(isNeedEditing)
                }
            }
        }
        OperationQueue().addOperation(removeNote)
    }
}
