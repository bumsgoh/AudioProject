//
//  musicData.swift
//  AudioProject
//
//  Created by 고상범 on 2018. 5. 18..
//  Copyright © 2018년 고상범. All rights reserved.
//


import UIKit

class MusicData {
    
    var songTitle : String
    var songArtist : String
    var songArtwork : UIImage
    var timeSecond : Double
    
    
    init(sTitle:String, sArtist:String, sArtwork:UIImage, sLength : Double) {
        songTitle = sTitle
        songArtist = sArtist
        songArtwork = sArtwork
        timeSecond = sLength
    }
}
