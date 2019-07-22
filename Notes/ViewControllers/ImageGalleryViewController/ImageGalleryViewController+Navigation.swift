//
//  ImageGalleryViewController+Navigation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Navigation
extension ImageGalleryViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "imageGalleryScrollViewSegue"  else { return }
        guard let destination = segue.destination as? ImageGalleryScrollViewController else { return }
        destination.images = imageGallery.images
        destination.currentIndex = currentIndex
    }
}
