//
//  GraphApi.swift
//  Social Photos
//
//  Created by shoulong li on 12/15/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKShareKit

class GraphApi {
    
    let ALBUMS_PARAMETERS = ["fields": "id, name, count, can_update, cover_photo, created_time, description, link, location, privacy, type, updated_time, from, place"]
    
    //albums
    func fetchAlbums(handler: ([Album] -> Void)) {
        //var albums: [Album] = []
        let request =  FBSDKGraphRequest(graphPath: "me/albums", parameters: ALBUMS_PARAMETERS)
        
        request.startWithCompletionHandler({(connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                print(error.localizedDescription)
            } else {
                //parse albums
                handler(self.parseAlbums(result))
                //print("\(albums)")
            }
        })
       // handler(albums)
    }
    
    func parseAlbums(result: AnyObject!) -> [Album] {
        var albums = [Album]()
        if let albumsJson = result as? NSDictionary {
            print(albumsJson)
            if let dataJson = albumsJson["data"] as? NSArray {
                //print(dataJson)
                for albumJson in dataJson {
                    //print(albumJson)
                    var album = Album(id: albumJson["id"] as? String, name: albumJson["name"] as? String, count: albumJson["count"] as? Int)
                    albums.append(album)
                    print(album)
                }
            }
            
            if let paging = albumsJson["paging"] as? NSDictionary {
                
            }
        }
        return albums
    }
    
    func createAlbum() -> Bool {
        
        return true
    }
}
