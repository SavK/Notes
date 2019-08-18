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
        if !userSettings.isLoginedInGitHub && userSettings.isInternetConnectionOn {
            sleep(1)
            self.requestToken()
        }
        
        OperationQueue.main.addOperation {
            self.activityIndicatorStart()
        }
        
        loadNotes.completionBlock = {
            let loadedNotes = loadNotes.result ?? []
            DDLogDebug(" \(loadedNotes.count) notes was uploaded")
            self.notes = loadedNotes
            OperationQueue.main.addOperation {
                self.activityIndicatorStop()
                self.tableView.reloadData()
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
            self.activityIndicatorStart()
        }
        ///Delete row with animation
        removeNote.completionBlock = {
            DDLogDebug("Removed tableViewCell at row: \(indexPath.row)")
            OperationQueue.main.addOperation {
                UIView.animate(withDuration: 0.5) {
                    self.activityIndicatorStop()
                    self.notes.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                }
            }
        }
        OperationQueue().addOperation(removeNote)
    }
}
