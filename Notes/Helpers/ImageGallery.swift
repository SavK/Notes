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
    // MARK: - Properties
    public private(set) var images: [UIImage]
    let documentDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                     in: .userDomainMask).first!
    
    // MARK: - Functions
    public func add(image: UIImage) {
        self.images.append(image)
    }
    
    func getCacheFileDirectory() -> URL {
        let directoryURL = documentDirectory.appendingPathComponent("NotebookImageGallery")
        var DirectoryExists: ObjCBool = false
        if !FileManager.default.fileExists(atPath: directoryURL.path,
                                           isDirectory: &DirectoryExists), !DirectoryExists.boolValue {
            do {
                try FileManager.default.createDirectory(at: directoryURL,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            }
            catch { DDLogError("ERROR: Can't create image cache directory") }
        }
        return directoryURL
    }
    
    /// Save images as PNG Data into files
    public func saveImagesToFile() {
        let URLs = try? FileManager.default.contentsOfDirectory(at: getCacheFileDirectory(),
                                                                includingPropertiesForKeys: nil,
                                                                options: .skipsHiddenFiles)
        
        guard let imagePaths = URLs else { return }
        imagePaths.forEach {
            do { try FileManager.default.removeItem(at: $0)
            } catch { DDLogError("ERROR: Can't remove image from cache directory. Image URL: \($0)") }
        }
        
        for (index, image) in images.enumerated() {
            let imageURL = getCacheFileDirectory().appendingPathComponent("IMG\(index).png")
            do { try image.pngData()?.write(to: imageURL)
            } catch { DDLogError("ERROR: Can't write image to cache directory. Image index: \(index)") }
        }
    }
    
    /// Load PNG Data from files and update images
    public func loadImagesFromFile() {
        var newImages: [UIImage] = []
        let URLs = try? FileManager.default.contentsOfDirectory(at: getCacheFileDirectory(),
                                                                includingPropertiesForKeys: nil,
                                                                options: .skipsHiddenFiles)
        
        guard var imagePaths = URLs else { return }
        imagePaths.sort(by: {
            $0.absoluteString.compare($1.absoluteString, options: .numeric) == .orderedAscending
        })
        
        imagePaths.forEach {
            if let imageData = try? Data(contentsOf: $0), let image = UIImage(data: imageData) {
                newImages.append(image)
            }
        }
 
        if newImages.count != 0 { images = newImages }
    }
}
