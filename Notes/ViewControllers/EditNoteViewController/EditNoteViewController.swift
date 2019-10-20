//
//  EditNoteViewController.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/18/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CoreData

class EditNoteViewController: UIViewController {
    
    // MARK: - IB Outlets
    /// View
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var scrollView: UIScrollView!
    /// Text
    @IBOutlet var noteTitleTextField: UITextField!
    @IBOutlet var noteContentTextView: UITextView!
    /// Self-destruction date picker
    @IBOutlet var selfDestructionDatePicker: UIDatePicker!
    @IBOutlet var selfDestructionDatePickerSwitch: UISwitch!
    @IBOutlet var selfDestructionDatePickerContainer: UIView!
    @IBOutlet var selfDestructionDatePickerContainerHeightConstraint: NSLayoutConstraint!
    ///Squares for select color
    @IBOutlet var whiteSquare: ColorSquareView!
    @IBOutlet var redSquare: ColorSquareView!
    @IBOutlet var greenSquare: ColorSquareView!
    @IBOutlet var customSquare: ColorSquareView!
    
    // MARK: - Properties
    let saveNoteActivityIndicator = UIActivityIndicatorView(style: .gray)
    let averageBrightness: CGFloat = 0.5
    var note = Note(title: "", content: "", importance: .normal, selfDestructionDate: nil)
    weak var delegate: NoteDelegate!
    /// Default palette color. Did set last selected color (or iridescent image)
    var color: [CGFloat] = [0.5, 0.5, 1] {
        didSet {
            pickSquare(square: customSquare)
            customSquare.isDarkColorSelect = color[HSB.brightness.index] < averageBrightness
            customSquare.squareColor = UIColor(hue: color[HSB.hue.index],
                                               saturation: 1 - color[HSB.saturation.index],
                                               brightness: color[HSB.brightness.index],
                                               alpha: 1)
        }
    }
    /// CoreData context
    var backgroundContext: NSManagedObjectContext!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNoteData()
        selfDestructionDatePicker.minimumDate = Date()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        noteTitleTextField.delegate = self
    }
    
    // MARK: - IB Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        setupSaveNoteActivityIndicator()
        saveNoteData()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    /// Show date picker with animation
    @IBAction func onSwitchChangedState(_ sender: UISwitch) {
        
        UIView.animate(withDuration: 1) {
            let oldContainerHeight = self.selfDestructionDatePickerContainerHeightConstraint.constant
            self.selfDestructionDatePickerContainer.isHidden = !sender.isOn
            self.stackView.layoutIfNeeded()
            
            var updatedOffset = self.scrollView.contentOffset
            updatedOffset.y += self.selfDestructionDatePickerContainerHeightConstraint.constant - oldContainerHeight
            self.scrollView.setContentOffset(updatedOffset, animated: false)
        }
    }
    
    @IBAction func selectSquare(_ sender: UITapGestureRecognizer) {
        if (sender.view as? ColorSquareView)?.squareColor != nil {
            pickSquare(square: sender.view as? ColorSquareView)
        } else {
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            UIAlertController.showAlert(withTitle: "Color picker",
                                        message: "For open the color palette please press and hold (make long tap)",
                                        actions: [alertAction],
                                        target: self)
        }
    }
    
    @IBAction func squareLongTapped(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        performSegue(withIdentifier: "showColorPicker", sender: nil)
    }
}
