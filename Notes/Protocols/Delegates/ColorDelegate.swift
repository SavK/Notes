//
//  ColorDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreGraphics

protocol ColorDelegate: class {
    var color: [CGFloat] { get set }
}
