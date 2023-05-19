//
//  UserProfileCommonCell.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit

class UserProfileCommonCell: UITableViewCell {

    @IBOutlet weak var imageviewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!{
        didSet {
            labelTitle.font = CustomFont.THEME_FONT_Book(14)
            labelTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelValue: UILabel!{
        didSet {
            labelValue.font = CustomFont.THEME_FONT_Medium(14)
            labelValue.textColor = Constants.color_DarkGrey
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
