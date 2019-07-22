//
//  ImageGalleryViewController+ UICollectionViewDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDelegate
extension ImageGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        performSegue(withIdentifier: "imageGalleryScrollViewSegue", sender: nil)
    }
}
