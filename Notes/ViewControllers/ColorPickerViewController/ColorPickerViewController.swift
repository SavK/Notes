//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var colorPickerView: ColorPickerView!
    
    // MARK: - Properties
    var color: [CGFloat] = [0, 0, 1]
    var delegate: ColorDelegate!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.color = delegate.color
        colorPickerView.delegate = self
    }
    
    // MARK: - IB Actions
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        delegate.color = color
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
