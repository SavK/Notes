//
//  ImageGalleryViewController+UICollectionViewDelegateFlowLayout.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDelegateFlowLayout
extension ImageGalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sideConstraint
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let countOfSides: CGFloat = 4
        let proportionOfImagePerLine: CGFloat = 3
        
        let availableWidth = collectionView.frame.width - sideConstraint * countOfSides
        let itemWidth = floor(availableWidth / proportionOfImagePerLine)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: sideConstraint,
                            left: sideConstraint,
                            bottom: sideConstraint,
                            right: sideConstraint)
    }
    
}
