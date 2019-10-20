//
//  NotesTableViewController+Selectors.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/22/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Selectors
extension NotesTableViewController {
    
    @objc func saveNotes() {
        do { try noteBook.saveNotesToFile()
        } catch {
            UIAlertController.showErrorAlert(withTitle: "ERROR: Notes didn't saved",
                                             target: self)
        }
    }
}
