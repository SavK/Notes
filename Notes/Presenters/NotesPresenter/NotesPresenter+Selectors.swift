//
//  NotesPresenter+Selectors.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Selectors
extension NotesPresenter {
    
    @objc func saveNotes() {
        do { try noteBook.saveNotesToFile()
        } catch {
            UIAlertController.showErrorAlert(withTitle: "ERROR: Notes didn't saved",
                                             target: viewController)
        }
    }
}
