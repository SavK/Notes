//
//  NoteProtocol.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/18/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreGraphics
import Foundation

protocol NoteProtocol {
    var title: String { get }
    var content: String { get }
    var color: NoteColorProtocol { get }
    var importance: Importance { get }
    var selfDestructionDate: Date? { get }
    var uid: String { get }
    
    func createColorArray() -> [CGFloat]
}
