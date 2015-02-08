//
//  DVDCellTableViewCell.swift
//  Rahten Toemay Toes
//
//  Created by Adam Panzer on 2/8/15.
//  Copyright (c) 2015 Adam Panzer. All rights reserved.
//

import UIKit

class DVDCellTableViewCell: UITableViewCell {


    @IBOutlet weak var dvdSynopsis: UILabel!
    @IBOutlet weak var audienceRating: UIImageView!
    @IBOutlet weak var criticsRating: UIImageView!
    @IBOutlet weak var dvdPoster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
