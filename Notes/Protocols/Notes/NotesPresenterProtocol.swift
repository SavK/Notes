//
//  NotesPresenterProtocol.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import Network
import CoreData

protocol NotesPresenterProtocol: AuthenticationViewControllerDelegate, NoteDelegate {

    // MARK: - Properties
    /// View
    var viewController: NotesTableViewControllerProtocol { get }
    /// Model Properties
    var notes: [Note] { get set }
    var noteBook: FileNotebook { get }
    /// Concurrency
    var dbOperationQueue: OperationQueue { get }
    var backendOperationQueue: OperationQueue { get }
    /// Index of selected row
    var selectedIndex: Int? { get  set }
    /// Internet connection monitor
    var monitor: NWPathMonitor { get }
    var monitorNWConnectionQueue: DispatchQueue { get }
    /// CoreData context
    var backgroundContext: NSManagedObjectContext! { get set }
    
    // MARK: - Methods
    func handleTokenChanged(token: String)
    /// Custom Methods
    func loadNetworkConnectionMonitor()
    func requestToken()
    func newNoteButtonAction()
    /// Data Methods
    func loadNotesData()
    func removeNoteData(at indexPath: IndexPath)
    /// Navigation
    func prepareTransition(for segue: UIStoryboardSegue)
    /// NoteDelegate
    func addNote(_ note: Note)
    /// Selectors
    func saveNotes()
    /// TableView Methods
    func rowTapAction(forRowAt indexPath: IndexPath)
    func createTableViewCell(forRowAt indexPath: IndexPath) -> UITableViewCell
    func changeEditingStyleActions(editingStyle: UITableViewCell.EditingStyle,
                                   forRowAt indexPath: IndexPath)
}
