//
//  ImageGalleryScrollViewController.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class ImageGalleryScrollViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    // MARK: - Private Properties
    private var imageViews: [UIImageView] = []
    private var offset: CGFloat {
        return scrollView.frame.width * CGFloat(currentIndex)
    }
    
    // MARK: - Properties
    var images: [UIImage] = []
    var currentIndex = 0
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        tabBarController?.tabBar.isHidden = true
        pageControl.numberOfPages = images.count
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        
        images.forEach {
            let imageView = UIImageView(image: $0)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentOffset.x = offset
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame = CGRect(x: scrollView.frame.width * CGFloat(index),
                                     y: 0,
                                     width: scrollView.frame.width,
                                     height: scrollView.frame.height)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imageViews.count),
                                        height: scrollView.frame.height)
    }
    
    // MARK: - IB Actions
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        let prevIndex = currentIndex
        currentIndex = sender.currentPage
        sender.currentPage = prevIndex
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
}
