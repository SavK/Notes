//
//  NotesTableViewController+UITableViewDataSource.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CocoaLumberjack

// MARK: - UITableViewDataSource
extension NotesTableViewController {
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let note = notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell",
                                                 for: indexPath) as! NoteTableViewCell
        
        cell.noteColorView?.backgroundColor = note.color.currentColor
        cell.noteTitleLabel?.text = note.title
        cell.noteContentLabel?.text = note.content
        deleteNoteActivityIndicator.center = cell.noteColorView.center
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.reloadData()
            removeNoteData(at: indexPath)
        }
    }
}
