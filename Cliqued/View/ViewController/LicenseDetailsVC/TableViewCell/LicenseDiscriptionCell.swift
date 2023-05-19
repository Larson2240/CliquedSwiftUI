//
//  LicenseDiscriptionCell.swift
//  Cliqued
//
//  Created by C211 on 27/04/23.
//

import UIKit

class LicenseDiscriptionCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!{
        didSet {
            labelTitle.font = CustomFont.THEME_FONT_Bold(18)
            labelTitle.textColor = Constants.color_DarkGrey
            labelTitle.text = "Here are the libraries we're using"
        }
    }
    @IBOutlet weak var labelDescription: UILabel!{
        didSet {
            labelDescription.font = CustomFont.THEME_FONT_Regular(13)
            labelDescription.textColor = Constants.color_DarkGrey
            labelDescription.text = "The build that you are correctly experiencing was in part possible due to the many contribution of the open-source community. As we've found out, standing of the shoulder of gaints make thing much easier."
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
