//
//  ImageGalleryViewController+UICollectionViewDataSource.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension ImageGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageGallery.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageGalleryCell",
                                                      for: indexPath)
        
        let imageView = UIImageView(image: imageGallery.images[indexPath.row])
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.frame = cell.bounds
        imageView.contentMode = .scaleAspectFill
        cell.addSubview(imageView)
        
        return cell
    }
}


