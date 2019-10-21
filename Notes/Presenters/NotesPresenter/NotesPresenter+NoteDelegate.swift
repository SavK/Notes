//
//  NotesPresenter+NoteDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

// MARK: - NoteDelegate
extension NotesPresenter: NoteDelegate {
    
    func addNote(_ note: Note) {
        noteBook.remove(noteWith: note.uid)
        noteBook.add(note: note)
        if let index = selectedIndex {
            viewController.tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: 0, section: 0))
            viewController.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        } else {
            viewController.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        }
    }
}
