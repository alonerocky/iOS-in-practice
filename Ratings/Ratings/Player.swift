//
//  Player.swift
//  Ratings
//
//  Created by shoulong li on 12/13/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import Foundation

struct Player {
    var name: String?
    var game: String?
    var rating: Int
    
    init(name: String?, game: String?, rating: Int) {
        self.name = name
        self.game = game
        self.rating = rating
    }
}
