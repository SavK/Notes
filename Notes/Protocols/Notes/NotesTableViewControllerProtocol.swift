//
//  NotesTableViewControllerProtocol.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

protocol NotesTableViewControllerProtocol: class {
    
    // MARK: - Properties
    var presenter: NotesPresenterProtocol! { get set }
    
    // MARK: - Methods
    /// Alerts
    func showAuthorizationAlert()
    func showErrorAlert(withTitle title: String)
    /// Custom Methods
    func requestToken()
    func isNeedEditNotes(_ status: Bool)
    func updateSelectedRow()
    func deleteTableViewRow(atIndex index: Int)
    func reloadTableViewData()
    func deleteNoteActivityIndicatorStart()
    func deleteNoteActivityIndicatorStop()
}
