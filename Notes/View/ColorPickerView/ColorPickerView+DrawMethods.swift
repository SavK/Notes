//
//  ColorPickerView+DrawMethods.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Draw Methods
extension ColorPickerView {
    
    /// Draw separator line between current color and hex label
    func drawCurrentColorSeparator() {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: currentColorHex.frame.width, y:0))
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = borderWidth
        shapeLayer.position = CGPoint(x: currentColorHex.frame.minX,
                                      y: currentColorHex.frame.minY)
        
        currentColorView.layer.addSublayer(shapeLayer)
    }
    
    func drawCursor() {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let arcSide: CGFloat = 12
        let radius: CGFloat = 7
        
        path.addArc(withCenter: CGPoint(x: arcSide, y: arcSide),
                    radius: radius,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: true)
        
        path.move(to: CGPoint(x: arcSide, y: arcSide - radius))
        path.addLine(to: CGPoint(x: arcSide, y: 0))
        path.move(to: CGPoint(x: arcSide, y: arcSide + radius))
        path.addLine(to: CGPoint(x: arcSide, y: 2 * arcSide))
        path.move(to: CGPoint(x: arcSide - radius, y: arcSide))
        path.addLine(to: CGPoint(x: 0, y: arcSide))
        path.move(to: CGPoint(x: arcSide + radius, y: arcSide))
        path.addLine(to: CGPoint(x: arcSide * 2, y: arcSide))
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = borderWidth + 0.5
        shapeLayer.fillColor = UIColor(white: 1, alpha: 0).cgColor
        shapeLayer.position = CGPoint(x: cursorView.bounds.minX, y: cursorView.bounds.minY)
        
        cursorView.layer.addSublayer(shapeLayer)
        cursorView.isOpaque = false
    }
}
