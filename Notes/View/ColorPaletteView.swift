//
//  ColorPalette.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class ColorPaletteView : UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawPalette()
    }
    
    /// Draw palette of small color squares
    private func drawPalette() {
        let paletteWidth = self.bounds.width
        let paletteHeight = self.bounds.height
        let width: CGFloat = 2
        let height: CGFloat = 2

        for x in stride(from: 0, to: paletteWidth, by: width) {
            guard paletteWidth.isMoreThenZero(), paletteHeight.isMoreThenZero() else { return }
            
            let hue = x / paletteWidth
            
            for y in stride(from: 0, to: paletteHeight, by: height) {
                UIColor(hue: hue, saturation: 1 - y / paletteHeight, brightness: 1, alpha: 1).setFill()
                UIBezierPath(rect: CGRect(x: x, y: y, width: width, height: height)).fill()
            }
        }
    }
}
