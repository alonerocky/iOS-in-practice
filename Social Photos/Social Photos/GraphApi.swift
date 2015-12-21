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
    
    let ALBUMS_PARAMETERS = ["fields": "id, name, count, cover_photo, created_time, description, location, type, from"]
    
    let PHOTO_PARAMETERS = ["fields": "id, name, created_time, picture"]
    
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
            }
        })
       // handler(albums)
    }
    
    func parseAlbums(result: AnyObject!) -> [Album] {
        var albums = [Album]()
        if let albumsJson = result as? NSDictionary {
            if let dataJson = albumsJson["data"] as? NSArray {
                for albumJson in dataJson {
                    var album = Album(id: albumJson["id"] as? String, name: albumJson["name"] as? String, count: albumJson["count"] as? Int)
                    albums.append(album)
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
    
    func fetchPhotos(albumid: String, handler: ([Photo] -> Void)) {
        let request =  FBSDKGraphRequest(graphPath: "\(albumid)/photos", parameters: PHOTO_PARAMETERS)
        request.startWithCompletionHandler({(connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                
            } else {
                handler(self.parsePhotos(result))
            }
        
        })
    }
    
    func parsePhotos(result: AnyObject!) -> [Photo] {
        var photos = [Photo]()
        if let photosJson = result as? NSDictionary {
            if let dataJson = photosJson["data"] as? NSArray {
                for photoJson in dataJson {
                    var photo = Photo(id: photoJson["id"] as? String, name: photoJson["name"] as? String, picture: photoJson["picture"] as? String, created_time: photoJson["created_time"] as? String)
                    photos.append(photo)
                }
            }
            
            if let paging = photosJson["paging"] as? NSDictionary {
                
            }
        }
        return photos
    }

    
}
