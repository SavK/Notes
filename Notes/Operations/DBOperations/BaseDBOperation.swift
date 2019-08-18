//
//  BaseDBOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreData

class BaseDBOperation: AsyncOperation {
    let notebook: FileNotebook
    let backgroundContext: NSManagedObjectContext
    
    init(notebook: FileNotebook, backgroundContext: NSManagedObjectContext) {
        self.backgroundContext = backgroundContext
        self.notebook = notebook
        super.init()
    }
}

