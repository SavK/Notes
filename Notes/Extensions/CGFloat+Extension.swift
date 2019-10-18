//
//  CGFloat+Extension.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/18/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    func isMoreThenZero() -> Bool {
        return CGFloat(0).isLess(than: self)
    }
}
