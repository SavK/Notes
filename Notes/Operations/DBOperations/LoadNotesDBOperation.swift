//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation
import CocoaLumberjack

class LoadNotesDBOperation: BaseDBOperation {
    private(set) var result: [Note]?
    
    override func main() {
        do {
            try notebook.loadFromFile()
            DDLogDebug("Load notes from db: SUCCESS")
        } catch {
          DDLogError("Load notes from db: ERROR (\(error))")
        }
        result = notebook.notes
        finish()
    }
}
