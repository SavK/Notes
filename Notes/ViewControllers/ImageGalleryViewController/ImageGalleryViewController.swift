//
//  ImageGalleryViewController.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Properties
    let sideConstraint: CGFloat = 16
    var currentIndex = 0
    var imageGallery = ImageGallery()
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageGallery.loadImagesFromFile()
        NotificationCenter.default.addObserver(self, selector: #selector(saveImages),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - IB Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let imageSource = UIAlertController(title: "Please select image source",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        imageSource.addAction(UIAlertAction(title: "Camera",
                                            style: .default,
                                            handler: { (_ :UIAlertAction) in
                                                
                                                guard UIImagePickerController.isSourceTypeAvailable(.camera)
                                                    else { return }
                                                
                                                imagePickerController.sourceType = .camera
                                                self.present(imagePickerController,
                                                             animated: true,
                                                             completion: nil)
        }))
        
        imageSource.addAction(UIAlertAction(title: "Photo Gallery",
                                            style: .default,
                                            handler: { (_ :UIAlertAction) in
                                                
                                                imagePickerController.sourceType = .photoLibrary
                                                self.present(imagePickerController,
                                                             animated: true,
                                                             completion: nil)
        }))
        
        imageSource.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(imageSource, animated: true, completion: nil)
    }
}
