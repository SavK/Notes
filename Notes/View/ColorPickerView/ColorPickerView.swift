//
//  ColorPickerView.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// Вью для выбора цвета, загружает из ColorPickerView.xib

@IBDesignable
class ColorPickerView : UIView {
    
    // MARK: - IB Outlets
    @IBOutlet weak var backgroundColorPaletteView: UIView!
    @IBOutlet weak var brightnessCorrector: UISlider!
    @IBOutlet weak var currentColorView: UIView!
    @IBOutlet weak var currentColorHex: UILabel!
    
    // MARK: - Properties
    let paletteView = ColorPaletteView()
    let cursorView = UIView()
    let cursorDiametr: CGFloat = 24
    
    var delegate: ColorDelegate!
    
    var colorPaletteViewHeight: CGFloat = 0
    var colorPaletteViewWidth: CGFloat = 0
    var currentColor: UIColor {
        return UIColor(hue: delegate.color[0],
                       saturation: 1 - delegate.color[1],
                       brightness: delegate.color[2],
                       alpha: 1)
    }
    
    var currentColorHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        currentColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return "#" + String(format: "%.2X", Int(round(r*255))) + String(format: "%.2X", Int(round(g*255)))
            + String(format: "%.2X", Int(round(b*255)))
    }
    
    // MARK: - Initializators
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    // MARK: - IB Actions
    @IBAction func correctBrightness(_ sender: UISlider) {
        delegate.color[2] = CGFloat(sender.value)
        updateUI()
    }
    
    @IBAction func onPalettePanned(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .began || sender.state == .changed else { return }
        paletteWasTouched(sender)
    }
    
    @IBAction func onPaletteTapped(_ sender: UITapGestureRecognizer) {
        paletteWasTouched(sender)
    }
    
    func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorPickerView", bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    // MARK: - Custom Methods
    /// Sizing calculation for limit drawing cursor
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorPaletteViewWidth = self.bounds.width - 16 * 2
        colorPaletteViewHeight = self.bounds.height - 8 - 16 * 2 - currentColorView.frame.height
        updateUI()
    }
    
    private func paletteWasTouched(_ sender: UIGestureRecognizer) {
        let touchPoint = sender.location(in: backgroundColorPaletteView)
        delegate.color[0] = checkCursorInBounds(touchPoint.x / colorPaletteViewWidth)
        delegate.color[1] = checkCursorInBounds(touchPoint.y / colorPaletteViewHeight)
        updateUI()
    }
    
    /// Check that cursor into bounds [0; 1]
    private func checkCursorInBounds(_ cursor: CGFloat) -> CGFloat {
        if cursor < 0 {
            return 0
        }
        if cursor > 1 {
            return 1
        }
        return cursor
    }
}
