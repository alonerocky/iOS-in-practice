//
//  AlbumList.swift
//  Social Photos
//
//  Created by shoulong li on 12/15/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import Foundation

struct AlbumList {
    var albums: [Album]
    
    init() {
        albums = []
    }
    
    init(albums: [Album]) {
        self.albums = albums
    }
}