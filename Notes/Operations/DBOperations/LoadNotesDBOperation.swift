//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {
    private(set) var result: [Note] = []
    
    override func main() {
        try? notebook.loadFromFile()
        result = notebook.notes
        finish()
    }
}
