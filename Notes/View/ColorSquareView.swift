//
//  ColorSquareView.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/18/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class ColorSquareView : UIView {
    
    // MARK: - Properies
    let borderWidth: CGFloat = 1.5
    var iridescentImage: UIImageView?
    @IBInspectable var squareColor: UIColor? {
        get {
            return self.backgroundColor
        }
        set {
            self.subviews.forEach { $0.removeFromSuperview() }
            self.backgroundColor = newValue
            self.setNeedsDisplay()
        }
    }
    
    var isDarkColorSelect = false
    var isSelect: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// Draw circle with tick
    private func createCheckmarkPath() {
        let sideIdent: CGFloat = 20
        let lineLength: CGFloat = 5
        let path = UIBezierPath()
        
        path.lineWidth = borderWidth
        /// Draw circle
        path.addArc(withCenter: CGPoint(x: self.bounds.width - sideIdent, y: sideIdent),
                    radius: 13,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        ///Draw tick
        path.move(to: CGPoint(x: self.bounds.width - sideIdent - lineLength, y: sideIdent))
        path.addLine(to: CGPoint(x: self.bounds.width - sideIdent, y: sideIdent + lineLength))
        path.addLine(to: CGPoint(x: self.bounds.width - sideIdent + lineLength, y: sideIdent - lineLength))
        
        isDarkColorSelect ? UIColor.white.setStroke() : UIColor.black.setStroke()
        path.stroke()
    }
    
    /// Add iridescent background image to square as subview
    private func setIridescentBackgroundImage() {
        let paletteIcon = UIImage.init(named: "paletteIcon")
        iridescentImage = UIImageView(image: paletteIcon)
        iridescentImage?.frame = self.bounds
        iridescentImage?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        if let iridescentImage = iridescentImage {
            self.addSubview(iridescentImage)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = borderWidth
        
        if squareColor == nil {
            setIridescentBackgroundImage()
        }
        
        if isSelect {
            createCheckmarkPath()
        }
    }
}
