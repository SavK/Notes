//
//  EditNoteViewController+Navigation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/18/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Navigation
extension EditNoteViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showColorPicker" else { return }
        guard let destination = segue.destination as? ColorPickerViewController else { return }
        destination.delegate = self
    }
}
