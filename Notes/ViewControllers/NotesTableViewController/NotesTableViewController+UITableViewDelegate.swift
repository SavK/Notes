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
        presenter.rowTapAction(forRowAt: indexPath)
    }
}
