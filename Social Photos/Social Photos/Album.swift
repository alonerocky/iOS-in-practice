//
//  Album.swift
//  Social Photos
//
//  Created by shoulong li on 12/15/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import Foundation

struct Album {
    
    /*
    https://developers.facebook.com/docs/graph-api/reference/v2.2/album
    */
    
    var id: String?
    var name: String?
    var count: Int?
    /*
    var can_update: Bool
    var count: Int = 0
    var cover_photo: String?
    var created_time: String? //date string
    var description: String?
    
    var link: String?
    var location: String?
    
    
    var privacy: String?
    var type: AlbumType
    var updated_time: String? //date string
    */
    /*
    Not used for now
    var from: User
    var place: Page
    */
    
    init(id: String?, name: String?, count: Int?) {
        self.id = id
        self.name = name
        self.count = count
    }
    
}
