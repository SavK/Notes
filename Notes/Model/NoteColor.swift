//
//  NoteColor.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/17/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

struct NoteColor: NoteColorProtocol {
    let currentColor: UIColor
    
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
}

extension NoteColor {
    
    init(currentColor: UIColor) {
        self.currentColor = currentColor
        
        self.red = currentColor.rgba.red
        self.green = currentColor.rgba.green
        self.blue = currentColor.rgba.blue
        self.alpha = currentColor.rgba.alpha
    }
}
