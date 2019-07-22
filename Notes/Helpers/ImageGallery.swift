//
//  ImageGallery.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ImageGallery {
    
    init() {
        self.images = [UIImage(named: "IMG1"),
                       UIImage(named: "IMG2"),
                       UIImage(named: "IMG3"),
                       UIImage(named: "IMG4"),
                       UIImage(named: "IMG5")].compactMap { $0 }
    }
    
    public private(set) var images: [UIImage]
    let documentDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                     in: .userDomainMask).first!
    public func add(_ image: UIImage) {
        self.images.append(image)
    }
    
    func getCacheFileDirectory() -> URL {
        let directoryURL = documentDirectory.appendingPathComponent("NotebookImageGallery")
        var DirectoryExists: ObjCBool = false
        if !FileManager.default.fileExists(atPath: directoryURL.path,
                                           isDirectory: &DirectoryExists), !DirectoryExists.boolValue {
            
            try? FileManager.default.createDirectory(at: directoryURL,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }
        return directoryURL
    }
    
    /// Save images as PNG Data into files
    public func saveToFile() {
        let URLs = try? FileManager.default.contentsOfDirectory(at: getCacheFileDirectory(),
                                                                includingPropertiesForKeys: nil,
                                                                options: .skipsHiddenFiles)
        
        guard let imagePaths = URLs else { return }
        for imagePath in imagePaths {
            try? FileManager.default.removeItem(at: imagePath)
        }
        
        for (index, image) in images.enumerated() {
            let imageURL = getCacheFileDirectory().appendingPathComponent("IMG\(index).png")
            try? image.pngData()?.write(to: imageURL)
        }
    }
    
    /// Load PNG Data from files and update images
    public func loadFromFile() {
        var newImages: [UIImage] = []
        let URLs = try? FileManager.default.contentsOfDirectory(at: getCacheFileDirectory(),
                                                                includingPropertiesForKeys: nil,
                                                                options: .skipsHiddenFiles)
        
        guard var imagePaths = URLs else { return }
        imagePaths.sort(by: {
            $0.absoluteString.compare($1.absoluteString, options: .numeric) == .orderedAscending
        })
        
        for imagePath in imagePaths {
            if let imageData: Data = try? Data(contentsOf: imagePath),
                let image: UIImage = UIImage(data: imageData) {
                newImages.append(image)
            }
        }
        if newImages.count != 0 {
            images = newImages
        }
    }
}
