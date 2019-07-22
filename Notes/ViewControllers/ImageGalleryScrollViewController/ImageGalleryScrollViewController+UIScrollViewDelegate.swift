//
//  ImageGalleryScrollViewController+UIScrollViewDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - UIScrollViewDelegate
extension ImageGalleryScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x / scrollView.frame.width).rounded())
        pageControl.currentPage = index
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = pageControl.currentPage
    }
}
