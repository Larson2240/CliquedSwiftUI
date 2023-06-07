//
//  TVSectionCell.swift
//  Cliqued
//
//  Created by C211 on 24/03/23.
//

import UIKit

class TVSectionCell: UITableViewCell {

    @IBOutlet weak var labelSectionTitle: UILabel!{
        didSet {
            labelSectionTitle.text = Constants.label_likes
            labelSectionTitle.font = CustomFont.THEME_FONT_Medium(16)
            labelSectionTitle.textColor = Constants.color_themeColor
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
