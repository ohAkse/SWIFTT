//
//  ImageCacheService.swift
//  SWIFTT
//
//  Created by 박유경 on 6/22/24.
//

import UIKit

protocol ImageCacheFetchable {
    func getCachedImage(for key: String) -> UIImage?
    func cacheImage(_ image: UIImage, for key: String)
}

class ImageCacheService: ImageCacheFetchable {
    static let shared = ImageCacheService()
    
    private let imageCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("ImageCache", isDirectory: true)
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func getCachedImage(for key: String) -> UIImage? {
        if let image = imageCache.object(forKey: key as NSString) {
            return image
        }
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        return nil
    }

    func cacheImage(_ image: UIImage, for key: String) {
        imageCache.setObject(image, forKey: key as NSString)
        if let data = image.jpegData(compressionQuality: 1.0) {
            let fileURL = cacheDirectory.appendingPathComponent(key)
            try? data.write(to: fileURL)
        }
    }
}
