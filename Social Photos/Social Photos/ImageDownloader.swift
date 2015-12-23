//
//  ImageDownloader.swift
//  Social Photos
//
//  Created by shoulong li on 12/23/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    
    func loadImage(imageUrl: String, completeHandler: (UIImage)->Void, errorHandler: ((NSError)->Void)?) {
        let url: NSURL = NSURL(string: imageUrl)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                if let image = UIImage(data: data!) {
                    completeHandler(image)
                }
            } else {
                errorHandler?(error!)
            }
        })
        dataTask.resume()
        
    }
}
