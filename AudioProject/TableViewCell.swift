//
//  TableViewCell.swift
//  AudioProject
//
//  Created by 고상범 on 2018. 5. 12..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cellSongTitle: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
