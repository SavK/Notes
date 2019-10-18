//
//  UIClolor+Extension.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/18/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Decompose the color value into RGBA
extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
    func getHsbColor() -> [CGFloat] {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        return [h, 1 - s, b]
    }
}
