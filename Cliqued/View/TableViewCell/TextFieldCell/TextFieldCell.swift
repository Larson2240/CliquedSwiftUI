//
//  TextFieldCell.swift
//  Cliqued
//
//  Created by C211 on 12/01/23.
//

import UIKit

class TextFieldCell: UITableViewCell {
    
    @IBOutlet weak var labelTextFieldTitle: UILabel!{
        didSet {
            labelTextFieldTitle.font = CustomFont.THEME_FONT_Medium(14)
            labelTextFieldTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var textfiled: UITextField!{
        didSet {
            textfiled.font = CustomFont.THEME_FONT_Medium(16)
            textfiled.textColor = Constants.color_DarkGrey
            textfiled.setLeftPadding(30)
            textfiled.setRightPadding(30)
        }
    }
    @IBOutlet weak var imageviewLeftSideIcon: UIImageView!
    @IBOutlet weak var buttonRightSideIcon: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
