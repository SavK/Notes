//
//  NotesTableViewController+NoteDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

// MARK: - NoteDelegate
extension NotesTableViewController: NoteDelegate {
    
    func addNote(_ note: Note) {
        noteBook.remove(with: note.uid)
        noteBook.add(note)
        if let index = selectedIndex {
            tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: 0, section: 0))
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        } else {
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        }
    }
}
