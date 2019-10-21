//
//  NotesPresenter.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CoreData
import Network

class NotesPresenter: NotesPresenterProtocol {
    /// View
    unowned let viewController: NotesTableViewControllerProtocol
    /// Model Properties
    var notes: [Note] = []
    let noteBook = FileNotebook.notebook
    /// Concurrency
    let dbOperationQueue = OperationQueue()
    let backendOperationQueue = OperationQueue()
    /// Index of selected row
    var selectedIndex: Int?
    /// Internet connection monitor
    let monitor = NWPathMonitor()
    let monitorNWConnectionQueue = DispatchQueue(label: "InternetConnectionMonitor")
    /// CoreData context
    var backgroundContext: NSManagedObjectContext!
    
    required init(viewController: NotesTableViewControllerProtocol) {
        self.viewController = viewController
        
        configurePresenter()
    }
    
    private func configurePresenter() {
        loadNetworkConnectionMonitor()
        
        dbOperationQueue.maxConcurrentOperationCount = 1
        backendOperationQueue.maxConcurrentOperationCount = 1
        
        viewController.tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil),
                                          forCellReuseIdentifier: "noteCell")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveNotes),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
}
