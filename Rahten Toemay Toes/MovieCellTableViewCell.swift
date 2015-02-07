//
//  MovieCellTableViewCell.swift
//  Rahten Toemay Toes
//
//  Created by Adam Panzer on 2/5/15.
//  Copyright (c) 2015 Adam Panzer. All rights reserved.
//

import UIKit

class MovieCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var audiencereviewImage: UIImageView!
    @IBOutlet weak var criticsratingImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var Synopsis: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
