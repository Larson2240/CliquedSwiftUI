//
//  ReceiverTVCell.swift
//  SwapItSports
//
//  Created by C100-132 on 25/05/22.
//

import UIKit

class ReceiverAudioTVCell: UITableViewCell {
   
    @IBOutlet var labelAudioTime: UILabel! {
        didSet {
            labelAudioTime.font = CustomFont.THEME_FONT_Regular(12)
            labelAudioTime.textColor = Constants.color_white
        }
    }
    @IBOutlet var labelDateTime: UILabel! {
        didSet {
            labelDateTime.font = CustomFont.THEME_FONT_Medium(10)
            labelDateTime.textColor = Constants.color_message_time
        }
    }
    @IBOutlet var buttonPlayAudio: UIButton!
    @IBOutlet var imageWaves: UIImageView! {
        didSet {
            imageWaves.tintColor = .white
        }
    }
    @IBOutlet var viewWavesImage: UIView!
      
    @IBOutlet var animationView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
