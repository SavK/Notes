//
//  ImageGalleryViewController+UIImagePickerControllerDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - UIImagePickerControllerDelegate
extension ImageGalleryViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageGallery.add(image)
        collectionView.insertItems(at: [IndexPath(row: imageGallery.images.count - 1, section: 0)])
        
        dismiss(animated: true)
    }
}
