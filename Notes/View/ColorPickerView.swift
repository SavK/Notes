//
//  ColorPickerView.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/14/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class ColorPickerView: UIView {
    
    //MARK: - Stored Properties
    private let brightnessSlider = UISlider()
    private let selectedColorView = UIView()
    private let colorLabel = UILabel()
    private let palette = ColorPalleteView()
    private let brightnessLabel = UILabel()
    private let doneButton = UIButton()
    private let singleMargin: CGFloat = 8
    private let doubleMargin: CGFloat = 16
    
    private var selectedColor: UIColor = UIColor.white
    
    // Delegate property for "done" button
    var onColorSelected: ((UIColor) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageWidth = CGFloat(80.0)
        selectedColorView.frame = CGRect(
            origin: CGPoint(x: bounds.minX + doubleMargin,
                            y: bounds.minY + doubleMargin),
            size: CGSize(width: imageWidth, height: imageWidth))
        
        let colorLabelSize = colorLabel.intrinsicContentSize
        colorLabel.frame = CGRect(
            origin: CGPoint(x: bounds.minX + doubleMargin,
                            y: bounds.minY + imageWidth + doubleMargin - CGFloat(1.0)),
            size: CGSize(width: imageWidth, height: colorLabelSize.height))
        
        let brightnessLabelSize = brightnessLabel.intrinsicContentSize
        brightnessLabel.frame = CGRect(
            origin: CGPoint(x: bounds.minX + doubleMargin + imageWidth + singleMargin,
                            y: bounds.minY + doubleMargin + imageWidth / 2.0),
            size: brightnessLabelSize)
        
        let brightnessSliderSize = brightnessSlider.intrinsicContentSize
        brightnessSlider.frame = CGRect(
            origin: CGPoint(x: bounds.minX + doubleMargin + imageWidth + singleMargin,
                            y: brightnessLabel.frame.maxY + singleMargin),
            size: CGSize(width: bounds.width - imageWidth - doubleMargin * 3.0,
                         height: brightnessSliderSize.height))
        
        let buttonSize = doneButton.intrinsicContentSize
        doneButton.frame = CGRect(
            origin: CGPoint(x: bounds.minX + (bounds.width - buttonSize.width) / 2,
                            y: bounds.maxY - buttonSize.height - doubleMargin),
            size: buttonSize)

        palette.frame = CGRect(
            origin: CGPoint(x: bounds.minX + doubleMargin,
                            y: colorLabel.frame.maxY + doubleMargin),
            size: CGSize(width: bounds.width - doubleMargin * 2.0,
                         height: bounds.height - imageWidth - colorLabelSize.height - buttonSize.height -
                            doubleMargin * 4.0))
        
        setNeedsDisplay()
    }
    
    
    private func setupViews() {
        
        addSubview(selectedColorView)
        addSubview(brightnessSlider)
        addSubview(brightnessLabel)
        addSubview(colorLabel)
        addSubview(doneButton)
        addSubview(palette)
        
        selectedColorView.translatesAutoresizingMaskIntoConstraints = true
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = true
        brightnessLabel.translatesAutoresizingMaskIntoConstraints = true
        colorLabel.translatesAutoresizingMaskIntoConstraints = true
        doneButton.translatesAutoresizingMaskIntoConstraints = true
        
        selectedColorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        selectedColorView.layer.borderColor = UIColor.black.cgColor
        selectedColorView.backgroundColor = selectedColor
        selectedColorView.layer.cornerRadius = 10
        selectedColorView.layer.borderWidth = 1
        
        colorLabel.text = getHexString(selectedColor)

        colorLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        colorLabel.layer.borderColor = UIColor.black.cgColor
        colorLabel.layer.cornerRadius = 10
        colorLabel.layer.borderWidth = 1

        brightnessSlider.addTarget(self, action: #selector(brightnessChanged),
                                   for: .valueChanged)
        brightnessSlider.maximumValue = 1.0
        brightnessSlider.minimumValue = 0
        
        brightnessLabel.text = "Brightness: "
        setBrightnessFromSelectedColor()
        
        palette.onColorDidChange = {[weak self] color, brightness in
            self?.onColorDidChange(color, brightness)
        }
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(actionButtonTapped),
                             for: .touchUpInside)
        doneButton.setTitleColor(doneButton.tintColor, for: .normal)
        
        setNeedsLayout()
    }

    @objc func actionButtonTapped() {
        onColorSelected?(selectedColor)
    }
    
    @objc func brightnessChanged() {
        var hue        : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha      : CGFloat = 0
        selectedColor.getHue(&hue,
                             saturation: &saturation,
                             brightness: &brightness,
                             alpha: &alpha)
        
        if (brightnessSlider.value == 0 && saturation > 0) {
            return
        }
        selectedColor = UIColor(hue: hue,
                                saturation: saturation,
                                brightness: CGFloat(brightnessSlider.value),
                                alpha: 1.0)
        
        updateSelectedColor()
    }
    
    private func onColorDidChange(_ color: UIColor, _ brightness: CGFloat) {
        selectedColor = color
        brightnessSlider.value = Float(brightness)
        updateSelectedColor()
    }
    
    private func updateSelectedColor() {
        selectedColorView.backgroundColor = selectedColor
        selectedColorView.setNeedsLayout()
        colorLabel.text = getHexString(selectedColor)
        colorLabel.setNeedsLayout()
    }
    
    private func setBrightnessFromSelectedColor() {
        
        var hue        : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha      : CGFloat = 0
        
        selectedColor.getHue(&hue,
                             saturation: &saturation,
                             brightness: &brightness,
                             alpha: &alpha)
        
        brightnessSlider.value = Float(brightness)
    }

    private func getHexString(_ color: UIColor) -> String {
        var r: CGFloat = 0.000
        var g: CGFloat = 0.000
        var b: CGFloat = 0.000
        var a: CGFloat = 0.000
        if (color.getRed(&r, green: &g, blue: &b, alpha: &a)) {
            let rgb = [r, g, b].map { $0 * 255 }.reduce("", {
                $0 + String(format: "%02x", Int($1))
            })
            return " #\(rgb)"
        } else {
            return " #000000"
        }
    }
}
