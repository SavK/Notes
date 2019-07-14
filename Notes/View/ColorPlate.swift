//
//  ColorPlate.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/14/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

//Color Palette
class ColorPalleteView : UIView {
    
    @IBInspectable var preSelectedColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var onColorDidChange: ((_ color: UIColor, _ brightness: CGFloat) -> Void)?
    
    let saturationExponentTop:Float = 1.0
    let saturationExponentBottom:Float = 1.5
    let elementSize: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self,
                                                        action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }
    
    private var sHue : CGFloat = 0
    private var sSaturation : CGFloat = 0
    private var sBrightness : CGFloat = 0
    private var sAlpha      : CGFloat = 0
    private var selectedX:CGFloat = 0
    private var selectedY:CGFloat = 0
    private var displayPointer = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for y in stride(from: CGFloat(0), to: rect.height, by: elementSize) {
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height :
                2.0 * CGFloat(rect.height - y) / rect.height
            
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop :
                saturationExponentBottom))
            
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            
            for x in stride(from: (0 as CGFloat), to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue,
                                    saturation: saturation,
                                    brightness: brightness,
                                    alpha: 1.0)
                
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x,
                                     y: y + rect.origin.y,
                                     width: elementSize,
                                     height: elementSize))
            }
        }
        
        UIColor.black.set()
        let border = UIBezierPath(rect: rect)
        border.lineWidth = 2
        border.stroke()
        
        if (displayPointer) {
            UIColor.white.set()
            let pointerDiameter = CGFloat(10.0)
            let pointerRect = CGRect(x:selectedX - pointerDiameter / 2.0,
                                     y:selectedY - pointerDiameter / 2.0,
                                     width:pointerDiameter,
                                     height:pointerDiameter)
            
            let path = UIBezierPath(ovalIn: pointerRect)
            path.lineWidth = 2
            path.stroke()
        }
        displayPointer = false
    }
    
    
    
    func getColorAtPoint(point: CGPoint) -> (UIColor, CGFloat) {
        let roundedPoint = point
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height :
            2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) :
            2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height

        let hue = roundedPoint.x / self.bounds.width
        
        return (UIColor(hue: hue,
                        saturation: saturation,
                        brightness: brightness,
                        alpha: 1.0),
                brightness)
    }
    
    
    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        self.onColorDidChange?(color.0, color.1)
        
        selectedX = point.x
        selectedY = point.y
        displayPointer = true
        preSelectedColor = color.0
    }
}
