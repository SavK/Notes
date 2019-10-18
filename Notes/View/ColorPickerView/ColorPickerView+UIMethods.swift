//
//  ColorPickerView+UIMethods.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - UI Methods
extension ColorPickerView {
    
    func updateUI() {
        guard let delegate = delegate else { return }
        let halfCursorDiametr = cursorDiametr / 2
        
        currentColorHex.text = currentColorHexString
        currentColorView.backgroundColor = currentColor
        
        brightnessCorrector.value = Float(delegate.color[HSB.brightness.index])
        paletteView.layer.opacity = Float(delegate.color[HSB.brightness.index])
        
        cursorView.frame = CGRect(x: delegate.color[HSB.hue.index]
                                    * colorPaletteViewWidth - halfCursorDiametr,
                                  y: delegate.color[HSB.saturation.index]
                                    * colorPaletteViewHeight - halfCursorDiametr,
                                  width: cursorDiametr,
                                  height: cursorDiametr)
        
        if delegate.color[HSB.brightness.index] < averageBrightness {
            (cursorView.layer.sublayers?.first as? CAShapeLayer)?.strokeColor = UIColor.white.cgColor
        } else {
            (cursorView.layer.sublayers?.first as? CAShapeLayer)?.strokeColor = UIColor.black.cgColor
        }
    }
    
    func configureViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(xibView)
        
        paletteView.frame = backgroundColorPaletteView.bounds
        paletteView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        currentColorView.layer.borderColor = UIColor.black.cgColor
        currentColorView.layer.borderWidth = borderWidth
        currentColorView.layer.cornerRadius = 5
        
        drawCurrentColorSeparator()
        configureColorPaletteView()
    }
    
    func configureColorPaletteView() {
        backgroundColorPaletteView.clipsToBounds = true
        backgroundColorPaletteView.layer.borderColor = UIColor.black.cgColor
        backgroundColorPaletteView.layer.borderWidth = borderWidth
        
        backgroundColorPaletteView.addSubview(paletteView)
        backgroundColorPaletteView.addSubview(cursorView)
        
        drawCursor()
    }
}
