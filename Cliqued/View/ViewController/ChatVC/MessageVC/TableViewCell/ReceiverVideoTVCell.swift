//
//  ReceiverProfileTVCell.swift
//  SwapItSports
//
//  Created by C100-132 on 09/08/22.
//

import UIKit

class ReceiverVideoTVCell: UITableViewCell {
    
    @IBOutlet var imageReceiverBg: UIImageView!
    @IBOutlet var buttonImageTap: UIButton!
    @IBOutlet var blurView: UIVisualEffectView! {
        didSet{
            blurView.layer.cornerRadius = 15
        }
    }
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var buttonDownload: UIButton!
    @IBOutlet var imageMessage: UIImageView!
    @IBOutlet var subBlurView: UIView!
    
    @IBOutlet var labelTime: UILabel! {
        didSet {
            labelTime.font = CustomFont.THEME_FONT_Medium(10)
            labelTime.textColor = Constants.color_message_time
        }
    }    
    @IBOutlet var imageTypeIcon: UIImageView!
    @IBOutlet var viewOption: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageMessage.viewRoundCorners([.topLeft, .topRight, .bottomRight], radius: 15)
        self.viewOption.viewRoundCorners([.topLeft, .topRight, .bottomRight], radius: 15)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
