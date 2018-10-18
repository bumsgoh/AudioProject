//
//  MainTableViewCell.swift
//  AudioProject
//
//  Created by 고상범 on 2018. 5. 14..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var songTitle: UILabel!
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songArtist: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
