//
//  NotesTableViewController+CustomMethods.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/22/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Custom Methods
extension NotesTableViewController {
    
    /// Flip the value from end to beginning (new/edited cell added to first position)
    func flipCellIndex(_ currentIndex: Int) -> Int {
        return notebook.notes.count - currentIndex - 1
    }
    
    func toggleEditingMode(forButton button: UIBarButtonItem) {
        if !tableView.isEditing {
            tableView.setEditing(true, animated: true)
            button.title = "Cancel"
            button.tintColor = UIColor.red
        } else {
            tableView.setEditing(false, animated: true)
            button.title = "Edit"
            button.tintColor = view.tintColor
        }
    }
}
