//
//  EditNoteViewController.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/18/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController {
    
    // MARK: - IB Outlets
    /// View
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    /// Text
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteContentTextView: UITextView!
    /// Self-destruction date picker
    @IBOutlet weak var selfDestructionDatePickerSwitch: UISwitch!
    @IBOutlet weak var selfDestructionDatePickerContainer: UIView!
    @IBOutlet weak var selfDestructionDatePicker: UIDatePicker!
    ///Squares for select color
    @IBOutlet weak var whiteSquare: ColorSquareView!
    @IBOutlet weak var redSquare: ColorSquareView!
    @IBOutlet weak var greenSquare: ColorSquareView!
    @IBOutlet weak var customSquare: ColorSquareView!
    
    // MARK: - Properties
    var note = Note(title: "", content: "", importance: .normal, selfDestructionDate: nil)
    var delegate: NoteDelegate!
    /// Last selected color (or iridescent image)
    var color: [CGFloat] = [0.5, 0.5, 1] {
        didSet {
            pickSquare(square: customSquare)
            customSquare.isDarkColorSelect = color[2] < 0.5
            customSquare.squareColor = UIColor(hue: color[0],
                                               saturation: 1 - color[1],
                                               brightness: color[2],
                                               alpha: 1)
        }
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoteData()
        
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
        guard
            let title = noteTitleTextField.text,
            let content = noteContentTextView.text,
            let color = findSelectedColor()
            else { return }
        
        let selfDestructionDate: Date?
        selfDestructionDate = selfDestructionDatePickerContainer.isHidden ? nil : selfDestructionDatePicker.date
        
        let newNote: Note
        newNote = Note(title: title,
                       content: content,
                       importance: .normal,
                       color: color,
                       selfDestructionDate: selfDestructionDate,
                       uid: note.uid)
        
        if title != "" || content != "" {
            delegate.addNote(newNote)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    /// Show date picker with animation
    @IBAction func onSwitchChangedState(_ sender: UISwitch) {

        UIView.animate(withDuration: 1) {
            let oldContainerHeight = self.selfDestructionDatePickerContainer.frame.height
            self.selfDestructionDatePickerContainer.isHidden = !sender.isOn
            self.stackView.layoutIfNeeded()
            
            var updatedOffset = self.scrollView.contentOffset
            updatedOffset.y += self.selfDestructionDatePickerContainer.frame.height - oldContainerHeight
            self.scrollView.setContentOffset(updatedOffset, animated: false)
        }
    }
    
    @IBAction func selectSquare(_ sender: UITapGestureRecognizer) {
        if (sender.view as? ColorSquareView)?.squareColor != nil {
            pickSquare(square: sender.view as? ColorSquareView)
        } else {
            let alert = UIAlertController(title: "Color picker",
                                          message: "For open the color palette please press and hold (make long tap)",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func squareLongTapped(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        performSegue(withIdentifier: "showColorPicker", sender: nil)
    }
}
