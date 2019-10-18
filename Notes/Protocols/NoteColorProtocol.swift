//
//  NoteColorProtocol.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/18/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

protocol NoteColorProtocol {
    var currentColor: UIColor { get }
    
    var red: CGFloat { get }
    var green: CGFloat { get }
    var blue: CGFloat { get }
    var alpha: CGFloat { get }
}
