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
        
        currentColorView.backgroundColor = currentColor
        currentColorHex.text = currentColorHexString
        brightnessCorrector.value = Float(delegate.color[2])
        paletteView.layer.opacity = Float(delegate.color[2])
        cursorView.frame = CGRect(x: delegate.color[0]*colorPaletteViewWidth - cursorDiametr/2,
                                  y: delegate.color[1]*colorPaletteViewHeight - cursorDiametr/2,
                                  width: cursorDiametr,
                                  height: cursorDiametr)
        
        if delegate.color[2] < 0.5 {
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
        currentColorView.layer.borderWidth = 1.5
        currentColorView.layer.cornerRadius = 5
        
        drawCurrentColorSeparator()
        configureColorPaletteView()
    }
    
    func configureColorPaletteView() {
        backgroundColorPaletteView.clipsToBounds = true
        backgroundColorPaletteView.layer.borderColor = UIColor.black.cgColor
        backgroundColorPaletteView.layer.borderWidth = 1.5
        
        backgroundColorPaletteView.addSubview(paletteView)
        backgroundColorPaletteView.addSubview(cursorView)
        
        drawCursor()
    }
}
