//
//  NotesTableViewController+Navigation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/22/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Navigation
extension NotesTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepareTransition(for: segue)
    }
}
