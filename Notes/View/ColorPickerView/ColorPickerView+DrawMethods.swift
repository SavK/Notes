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
        shapeLayer.lineWidth = 1.5
        shapeLayer.position = CGPoint(x: currentColorHex.frame.minX, y: currentColorHex.frame.minY)
        currentColorView.layer.addSublayer(shapeLayer)
    }
    
    func drawCursor() {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: 12, y: 12),
                    radius: 7,
                    startAngle: 0,
                    endAngle: CGFloat(2*Double.pi),
                    clockwise: true)
        
        path.move(to: CGPoint(x: 12, y: 5))
        path.addLine(to: CGPoint(x: 12, y: 0))
        path.move(to: CGPoint(x: 12, y: 19))
        path.addLine(to: CGPoint(x: 12, y: 24))
        path.move(to: CGPoint(x: 5, y: 12))
        path.addLine(to: CGPoint(x: 0, y: 12))
        path.move(to: CGPoint(x: 19, y: 12))
        path.addLine(to: CGPoint(x: 24, y: 12))
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor(white: 1, alpha: 0).cgColor
        shapeLayer.position = CGPoint(x: cursorView.bounds.minX, y: cursorView.bounds.minY)
        
        cursorView.layer.addSublayer(shapeLayer)
        cursorView.isOpaque = false
    }
}
