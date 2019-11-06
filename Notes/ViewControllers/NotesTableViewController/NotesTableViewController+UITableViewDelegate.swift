//
//  NotesTableViewController+UITableViewDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - UITableViewDelegate
extension NotesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectedIndex = indexPath.row
        tableView.cellForRow(at: indexPath)?.isSelected = false
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
        
        performSegue(withIdentifier: "showEditView", sender: nil)
    }
}
