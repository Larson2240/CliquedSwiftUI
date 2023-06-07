//
//  ConnectedAccountCell.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit

class ConnectedAccountCell: UITableViewCell {

    @IBOutlet weak var imageviewIcon: UIImageView!
    @IBOutlet weak var labelSocialPlatformName: UILabel!{
        didSet {
            labelSocialPlatformName.font = CustomFont.THEME_FONT_Medium(14)
            labelSocialPlatformName.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelSocialEmailId: UILabel!{
        didSet {
            labelSocialEmailId.font = CustomFont.THEME_FONT_Regular(12)
            labelSocialEmailId.textColor = Constants.color_DarkGrey
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
