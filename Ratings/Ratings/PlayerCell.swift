//
//  PlayerCell.swift
//  Ratings
//
//  Created by shoulong li on 12/13/15.
//  Copyright © 2015 shoulong li. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var ratingImgView: UIImageView!
    var player: Player! {
        didSet {
            nameLabel.text = player.name
            gameLabel.text = player.game
            ratingImgView.image = imageForRating(player.rating)
            
        }
    
    }
    
    func imageForRating(rating: Int) -> UIImage? {
        let name = "\(rating)Stars"
        return UIImage(named: name)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
