//
//  Photo.swift
//  Social Photos
//
//  Created by shoulong li on 12/15/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import Foundation

struct Photo {
    /*
    https://developers.facebook.com/docs/graph-api/reference/photo/
    */
    var id: String?
    var name: String?
    var picture: String?
    var created_time: String?
    init(id: String?, name: String?, picture: String?, created_time: String?) {
        self.id = id
        self.name = name
        self.picture = picture
        self.created_time = created_time
    }
}
