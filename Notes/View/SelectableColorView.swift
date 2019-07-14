//
//  SelectableColorView.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/14/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class SelectableColorView: UIView {
    
    // MARK: Properties
    @IBInspectable var isSelected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var hasIridescentBackground: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var tickColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
}

// MARK: - Draw Methods
extension SelectableColorView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if hasIridescentBackground {
            drawIridescentBackground(rect)
        }
        
        tickColor.set()
        
        // If the background is the same as the tick color, change tick color
        if (!hasIridescentBackground && tickColor == backgroundColor) {
            if (tickColor != UIColor.lightGray) {
                UIColor.lightGray.set()
            } else {
                UIColor.black.set()
            }
        }
        
        // Draw the border
        let border = UIBezierPath(rect: rect)
        
        border.lineWidth = 2
        border.stroke()
        
        // Draw the tick for selected item if needed
        guard isSelected else { return }
        
        let side = rect.width / 3.0
        let margin = rect.width / 12.0
        
        let tickSize: CGSize = CGSize(width: side, height: side)
        let shapePosition = CGPoint(x: rect.maxX - tickSize.width - margin,
                                    y: rect.minY + margin)
        
        let path = getTickViewPath(in: CGRect(origin: shapePosition, size: tickSize))
        
        path.stroke()
    }
    
    func drawIridescentBackground(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let elementSize = CGFloat(1.0)
        
        for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height :
                2.0 * CGFloat(rect.height - y) / rect.height
            
            saturation = CGFloat(powf(Float(saturation), 0.0))
            let brightness = CGFloat(1.0)
            
            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue,
                                    saturation: saturation,
                                    brightness: brightness,
                                    alpha: 1.0)
                
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }
    
    private func getTickViewPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(ovalIn: rect)
        path.lineWidth = 1.5
        
        let x = rect.midX + rect.size.width * CGFloat(cos(Double.pi/4)) / 2
        let y = rect.midY - rect.size.width * CGFloat(sin(Double.pi/4)) / 2
        
        path.move(to: CGPoint(x: rect.minX + rect.width / 5.0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.size.width / 5.0))
        path.addLine(to: CGPoint(x: x, y: y))
        
        path.stroke()
        return path
    }
}
