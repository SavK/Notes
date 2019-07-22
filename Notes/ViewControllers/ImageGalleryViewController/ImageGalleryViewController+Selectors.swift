//
//  ImageGalleryViewController+Selectors.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

// MARK: - Selectors
extension ImageGalleryViewController {
    
    @objc func saveImages() {
        imageGallery.saveToFile()
    }
}
