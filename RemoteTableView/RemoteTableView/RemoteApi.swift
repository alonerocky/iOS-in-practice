//
//  RemoteApi.swift
//  RemoteTableView
//
//  Created by Shoulong Li on 12/3/15.
//  Copyright (c) 2015 Shoulong Li. All rights reserved.
//

import Foundation

class RemoteApi {
    
    func fetchData(urlPath: String, completeHandler: (NSData) -> Void, errorHandler: ((NSError)! -> Void)?) {
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let handler = {
            (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if error == nil {
                completeHandler(data)
            }
            errorHandler?(error)
        }
        let task = session.dataTaskWithURL(url!, completionHandler: handler)
        task.resume()
    }
}