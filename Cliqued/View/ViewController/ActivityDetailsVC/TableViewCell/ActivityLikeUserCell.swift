//
//  ActivityLikeUserCell.swift
//  Cliqued
//
//  Created by C211 on 24/03/23.
//

import UIKit

class ActivityLikeUserCell: UITableViewCell {

    @IBOutlet weak var imageviewUser: UIImageView!{
        didSet {
            imageviewUser.layer.cornerRadius = imageviewUser.frame.size.height / 2
        }
    }
    @IBOutlet weak var labelNameAndAge: UILabel!{
        didSet {
            labelNameAndAge.font = CustomFont.THEME_FONT_Bold(16)
            labelNameAndAge.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelKilometer: UILabel!{
        didSet {
            labelKilometer.font = CustomFont.THEME_FONT_Medium(14)
            labelKilometer.textColor = Constants.color_MediumGrey
        }
    }
    
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var buttonDislike: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
