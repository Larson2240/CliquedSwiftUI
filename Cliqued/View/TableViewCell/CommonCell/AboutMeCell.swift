//
//  AboutMeCell.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit

class AboutMeCell: UITableViewCell {

    @IBOutlet weak var labelAboutMeTitle: UILabel!{
        didSet {
            labelAboutMeTitle.text = Constants.label_aboutMe
            labelAboutMeTitle.font = CustomFont.THEME_FONT_Medium(16)
            labelAboutMeTitle.textColor = Constants.color_themeColor
        }
    }
    
    @IBOutlet weak var labelAboutMeText: UILabel!{
        didSet {
            labelAboutMeText.font = CustomFont.THEME_FONT_Book(14)
            labelAboutMeText.textColor = Constants.color_DarkGrey
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
