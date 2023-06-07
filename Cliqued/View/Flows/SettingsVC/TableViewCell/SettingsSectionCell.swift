//
//  SettingsSectionCell.swift
//  Cliqued
//
//  Created by C211 on 23/01/23.
//

import UIKit

class SettingsSectionCell: UITableViewCell {

    @IBOutlet weak var labelSectionTitle: UILabel!{
        didSet {
            labelSectionTitle.font = CustomFont.THEME_FONT_Bold(14)
            labelSectionTitle.textColor = Constants.color_DarkGrey
        }
    }
    
    @IBOutlet weak var labelBasicAccountTitle: UILabel!{
        didSet {
            labelBasicAccountTitle.font = CustomFont.THEME_FONT_Medium(14)
            labelBasicAccountTitle.textColor = Constants.color_themeColor
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
