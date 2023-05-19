//
//  SettingsRowCell.swift
//  Cliqued
//
//  Created by C211 on 23/01/23.
//

import UIKit

class SettingsRowCell: UITableViewCell {

    @IBOutlet weak var labelSettingsRowTitle: UILabel!{
        didSet {
            labelSettingsRowTitle.font = CustomFont.THEME_FONT_Regular(12)
            labelSettingsRowTitle.textColor = Constants.color_DarkGrey
        }
    }
    
    @IBOutlet var labelSettingSubTitle: UILabel! {
        didSet {
            labelSettingSubTitle.font = CustomFont.THEME_FONT_Regular(12)
            labelSettingSubTitle.textColor = Constants.color_DarkGrey
        }
    }
    
    
    @IBOutlet weak var imageviewNextArrow: UIImageView!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var imageviewBottomLine: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
