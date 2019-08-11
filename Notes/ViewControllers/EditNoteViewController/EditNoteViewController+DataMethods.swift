//
//  EditNoteViewController+DataMethods.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/10/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

// MARK: - Data Methods
extension EditNoteViewController {
    
    func saveNoteData() {
        guard
            let title = noteTitleTextField.text,
            let content = noteContentTextView.text,
            let color = findSelectedColor()
            else { return }
        
        let selfDestructionDate: Date?
        selfDestructionDate = selfDestructionDatePickerContainer.isHidden ? nil : selfDestructionDatePicker.date
        
        let newNote = Note(title: title,
                           content: content,
                           importance: .normal,
                           color: color,
                           selfDestructionDate: selfDestructionDate,
                           uid: note.uid)
        
        /// Add SaveNoteOperation
        if title != "" || content != "" {
            let saveNoteOperation = SaveNoteOperation(note: newNote,
                                                      notebook: FileNotebook.notebook,
                                                      backendQueue: OperationQueue(),
                                                      dbQueue: OperationQueue())
            
            saveNoteOperation.completionBlock = {
                OperationQueue.main.addOperation {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            OperationQueue().addOperation(saveNoteOperation)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func setupNoteData() {
        noteTitleTextField.text = note.title
        noteContentTextView.text = note.content
        
        if let date = note.selfDestructionDate {
            selfDestructionDatePickerSwitch.isOn = true
            selfDestructionDatePicker.date = date
        } else {
            selfDestructionDatePickerSwitch.isOn = false
            selfDestructionDatePickerContainer.isHidden = true
        }
        
        switch note.color {
        case .white:
            whiteSquare.isSelect = true
        case .red:
            redSquare.isSelect = true
        case .green:
            greenSquare.isSelect = true
        default:
            color = getHsbColor(of: note.color)
        }
    }
}
