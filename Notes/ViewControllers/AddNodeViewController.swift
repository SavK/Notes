//
//  AddNodeViewController.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/1/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class AddNodeViewController: UIViewController {
    
    // MARK: IB Outlets
    @IBOutlet weak var fullscreenColorPicker: ColorPickerView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateSwitch: UISwitch!
    
    @IBOutlet weak var defaultColorView: SelectableColorView!
    @IBOutlet weak var firstColorView: SelectableColorView!
    @IBOutlet weak var secondColorView: SelectableColorView!
    @IBOutlet weak var customColorView: SelectableColorView!
    
    // MARK: IB Actions
    @IBAction func switchChanged(_ sender: UISwitch) {
        updateDatePickerVisibility()
    }
    
    // MARK: - Stored Properties
    private var selectedColor = UIColor.white
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        hideKeyboardWhenTappedAround()
        
        /// Configuration switch and datePicker
        initDatePicker()
        
        /// Configuration contentTextView
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.cornerRadius = 5
        
        /// Color Picker initialization
        fullscreenColorPicker.onColorSelected = { [weak self] color in
            self?.customColorSelected(color)
        }
        
        /// Check clicked color views
        func tapColorViewChecker() -> UITapGestureRecognizer {
            return  UITapGestureRecognizer(target: self,
                                           action:  #selector(checkAction))
        }
        self.defaultColorView.addGestureRecognizer(tapColorViewChecker())
        self.firstColorView.addGestureRecognizer(tapColorViewChecker())
        self.secondColorView.addGestureRecognizer(tapColorViewChecker())
        self.customColorView.addGestureRecognizer(tapColorViewChecker())
        
        let longTapChecker = UILongPressGestureRecognizer(target: self,
                                                          action: #selector(checkLongTap))
        longTapChecker.minimumPressDuration = 1.0
        
        longTapChecker.delegate = self as? UIGestureRecognizerDelegate
        self.customColorView.addGestureRecognizer(longTapChecker)
    }
}

// MARK: - Tap selectors
extension AddNodeViewController {
    
    @objc func checkLongTap(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == UIGestureRecognizer.State.began {
            fullscreenColorPicker.isHidden = false
            scrollView.isHidden = true
        }
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        guard let senderView = sender.view as? SelectableColorView else {
            return
        }
        colorViewItemSelected(senderView)
    }
}

// MARK: - UI Methods
extension AddNodeViewController {
    
    private func initDatePicker() {
        datePicker.minimumDate = Date()
        updateDatePickerVisibility()
    }
    
    private func updateDatePickerVisibility() {
        datePicker.isHidden = !dateSwitch.isOn
        contentView.setNeedsLayout()
    }
    
    private func colorViewItemSelected(_ colorView: SelectableColorView) {
        
        
        /// Allert for long tap if color of iridescent
        if (colorView.hasIridescentBackground) {
            let alert = UIAlertController(title: "Color picker",
                                          message: "For open the color palette please press and hold (make long tap)",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        
        /// Remove the previous selection and select the curent color item
        if (!colorView.isSelected) {
            resetPreviouslySelected()
            colorView.isSelected = true
            selectedColor = colorView.backgroundColor ?? selectedColor
        }
    }
    
    /// Open main screen when color was selected
    ///
    /// - Parameter color: Selected Color
    private func customColorSelected(_ color: UIColor) {
        scrollView.isHidden = false
        fullscreenColorPicker.isHidden = true
        
        if (selectedColor != color) {
            selectedColor = color
            customColorView.backgroundColor = selectedColor
            customColorView.hasIridescentBackground = false
            colorViewItemSelected(customColorView)
        }
    }
    
    private func unselectViewToggle(_ view: SelectableColorView) {
        if (view.isSelected) {
            view.isSelected.toggle()
        }
    }
    
    private func resetPreviouslySelected() {
        unselectViewToggle(defaultColorView)
        unselectViewToggle(firstColorView)
        unselectViewToggle(secondColorView)
        unselectViewToggle(customColorView)
    }
}

// MARK: - Hide keyboard
extension AddNodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
