//
//  ImageCacheService.swift
//  SWIFTT
//
//  Created by 박유경 on 6/22/24.
//

import Foundation

protocol ImageCacheFetchable {
    func getCachedData(for key: String) -> Data?
    func cacheData(_ data: Data, for key: String)   
}

class ImageCacheService: ImageCacheFetchable {
    
    private let cache = NSCache<NSString, NSData>()
    
    func getCachedData(for key: String) -> Data? {
        if let cachedData = cache.object(forKey: key as NSString) {
            return cachedData as Data
        }
        
        if let cachedURL = getDiskCacheURL(for: key),
           let data = try? Data(contentsOf: cachedURL) {
            cache.setObject(data as NSData, forKey: key as NSString)
            return data
        }
        
        return nil
    }
    
    func cacheData(_ data: Data, for key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
        if let cachedURL = getDiskCacheURL(for: key) {
            try? data.write(to: cachedURL)
        }
    }
    
    private func getDiskCacheURL(for key: String) -> URL? {
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return cacheDirectory.appendingPathComponent(key)
    }
}
