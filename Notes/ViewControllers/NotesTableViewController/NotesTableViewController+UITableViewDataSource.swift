//
//  NotesTableViewController+UITableViewDataSource.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource
extension NotesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notebook.notes[flipCellIndex(indexPath.row)]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        cell.noteColorView?.backgroundColor = note.color
        cell.noteTitleLabel?.text = note.title
        cell.noteContentLabel?.text = note.content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            notebook.remove(with: notebook.notes[flipCellIndex(indexPath.row)].uid)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}
