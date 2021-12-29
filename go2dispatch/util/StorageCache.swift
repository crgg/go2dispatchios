//
//  Cache.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/26/21.
//

import Foundation
import UIKit


class StorageCacheManager {
 
    static let instance =  StorageCacheManager()
    
    private init() {}
    
    var imageCache: NSCache<NSString, UIImage>  = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100 // 100mb
        return cache
    }()
    
    func add(image: UIImage, name : String) {
        imageCache.setObject(image, forKey: name as NSString)
        print("Add to Cache!")
    }
    func remove(name : String) {
        imageCache.removeObject(forKey: name as NSString)
        print("Removed from cache!")
    }
    func get(name : String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
    
}
