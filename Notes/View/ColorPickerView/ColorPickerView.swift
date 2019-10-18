//
//  ColorPickerView.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

/// View for color select, loaded from ColorPickerView.xib

@IBDesignable
class ColorPickerView : UIView {
    
    // MARK: - IB Outlets
    @IBOutlet var backgroundColorPaletteView: UIView!
    @IBOutlet var brightnessCorrector: UISlider!
    @IBOutlet var currentColorView: UIView!
    @IBOutlet var currentColorHex: UILabel!
    /// Constraints Color View
    @IBOutlet var colorViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var colorViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var colorViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var colorViewTopConstraint: NSLayoutConstraint!
    /// Constraints Current Color View
    @IBOutlet var currentColorViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var currentColorViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    let paletteView = ColorPaletteView()
    let cursorView = UIView()
    
    let cursorDiametr: CGFloat = 24
    let averageBrightness: CGFloat = 0.5
    let borderWidth: CGFloat = 1.5
    
    weak var delegate: ColorDelegate!
    
    var colorPaletteViewHeight: CGFloat = 0
    var colorPaletteViewWidth: CGFloat = 0
    var currentColor: UIColor {
        return UIColor(hue: delegate.color[HSB.hue.index],
                       saturation: 1 - delegate.color[HSB.saturation.index],
                       brightness: delegate.color[HSB.brightness.index],
                       alpha: 1)
    }
    
    var currentColorHexString: String {
        let uInt8Max: CGFloat = 255
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        currentColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return "#" + String(format: "%.2X", Int(round(r * uInt8Max)))
            + String(format: "%.2X", Int(round(g * uInt8Max)))
            + String(format: "%.2X", Int(round(b * uInt8Max)))
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
        delegate.color[HSB.brightness.index] = CGFloat(sender.value)
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
        
        colorPaletteViewWidth = self.bounds.width
            - colorViewLeadingConstraint.constant - colorViewTrailingConstraint.constant
        
        colorPaletteViewHeight = self.bounds.height - currentColorViewHeightConstraint.constant
            - currentColorViewTopConstraint.constant - colorViewTopConstraint.constant
            - colorViewBottomConstraint.constant
        
        updateUI()
    }
    
    private func paletteWasTouched(_ sender: UIGestureRecognizer) {
        guard colorPaletteViewWidth.isMoreThenZero(), colorPaletteViewHeight.isMoreThenZero()
            else { return }
        
        let touchPoint = sender.location(in: backgroundColorPaletteView)
        delegate.color[HSB.hue.index] = checkCursorInBounds(touchPoint.x / colorPaletteViewWidth)
        delegate.color[HSB.saturation.index] = checkCursorInBounds(touchPoint.y / colorPaletteViewHeight)
        updateUI()
    }
    
    /// Check that cursor into bounds [0; 1]
    private func checkCursorInBounds(_ cursor: CGFloat) -> CGFloat {
        if cursor.isLess(than: 0) { return 0 }
        if CGFloat(1).isLess(than: cursor) { return 1 }

        return cursor
    }
}
