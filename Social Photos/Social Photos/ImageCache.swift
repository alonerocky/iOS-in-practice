//
//  ImageCache.swift
//  Social Photos
//
//  Created by shoulong li on 12/21/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    
    var imageCache: [String: UIImage] = [:]
    
    func get(url: String) -> UIImage? {
        return imageCache[url]
    }
    
    func put(url: String, image: UIImage) {
        imageCache[url] = image
    }
    
}
