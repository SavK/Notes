//
//  NotesTableViewController+Selectors.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/22/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

// MARK: - Selectors
extension NotesTableViewController {
    
    @objc func saveNotes() {
        noteBook.saveNotesToFile()
    }
}
