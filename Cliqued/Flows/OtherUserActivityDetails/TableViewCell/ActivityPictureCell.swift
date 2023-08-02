//
//  ActivityPictureCell.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit

class ActivityPictureCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!{
        didSet {
            viewMain.layer.cornerRadius = 50.0
        }
    }
    @IBOutlet weak var imageviewActivity: UIImageView!{
        didSet {
            imageviewActivity.layer.cornerRadius = 50.0
        }
    }
    @IBOutlet weak var labelCategoryName: UILabel!{
        didSet {
            labelCategoryName.font = CustomFont.THEME_FONT_Bold(16)
            labelCategoryName.textColor = Constants.color_white
        }
    }
    @IBOutlet weak var imageviewUser: UIImageView!{
        didSet {
            imageviewUser.layer.cornerRadius = imageviewUser.frame.size.height / 2
            imageviewUser.layer.borderWidth = 2.0
            imageviewUser.layer.borderColor = Constants.color_themeColor.cgColor
        }
    }
    @IBOutlet weak var buttonInfo: UIButton!
    
    @IBOutlet var buttonUserProfile: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageviewActivity.setGradientBackground1(colorTop: .clear, colorBottom: UIColor.black,viewHeight:200, viewWidth: imageviewActivity.frame.width)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
