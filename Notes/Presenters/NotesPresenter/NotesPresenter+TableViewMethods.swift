//
//  NotesPresenter+TableViewMethods.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - TableView Methods
extension NotesPresenter {
    
    func rowTapAction(forRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        viewController.tableView.cellForRow(at: indexPath)?.isSelected = false
        viewController.tableView.cellForRow(at: indexPath)?.isHighlighted = false
        
        viewController.performSegue(withIdentifier: "showEditView", sender: nil)
    }
    
    func createTableViewCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let cell = viewController.tableView.dequeueReusableCell(withIdentifier: "noteCell",
                                                                for: indexPath) as! NoteTableViewCell
        
        cell.noteColorView?.backgroundColor = note.color.currentColor
        cell.noteTitleLabel?.text = note.title
        cell.noteContentLabel?.text = note.content
        viewController.deleteNoteActivityIndicator.center = cell.noteColorView.center
        return cell
    }
    
    func changeEditingStyleActions(editingStyle: UITableViewCell.EditingStyle,
                                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewController.tableView.reloadData()
            removeNoteData(at: indexPath)
        }
    }
}
