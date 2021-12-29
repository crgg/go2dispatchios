//
//  PhotoModelCacheManager.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 12/27/21.
//

import Foundation

class PhotoModelCacheManager {
    static let instance =  PhotoModelCacheManager()
    
    private init() {}
    
    var imageCache: NSCache<NSString, UIImage>  = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 100 // 200mb
        return cache
    }()
    
    func add(key: String , value : UIImage) {
        imageCache.setObject(value, forKey: key as NSString)
        print("Add to Cache!")
    }
    func remove(value : String) {
        imageCache.removeObject(forKey: value as NSString)
        print("Removed from cache!")
    }
    func get(key : String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
    
     
}
