//
//  EmailAndPasswordCell.swift
//  Cliqued
//
//  Created by C211 on 23/01/23.
//

import UIKit

class EmailAndPasswordCell: UITableViewCell {

    @IBOutlet weak var labelEmailPasswordTitle: UILabel!{
        didSet {
            labelEmailPasswordTitle.font = CustomFont.THEME_FONT_Regular(12)
            labelEmailPasswordTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelEmailPasswordValue: UILabel!{
        didSet {
            labelEmailPasswordValue.font = CustomFont.THEME_FONT_Bold(12)
            labelEmailPasswordValue.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var imageviewBottomLine: UIImageView!
    @IBOutlet weak var imageviewNextArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
