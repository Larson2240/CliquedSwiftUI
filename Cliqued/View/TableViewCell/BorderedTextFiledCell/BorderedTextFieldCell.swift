//
//  BorderedTextFieldCell.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit

class BorderedTextFieldCell: UITableViewCell {

    @IBOutlet weak var labelTextFieldTitle: UILabel!{
        didSet {
            labelTextFieldTitle.font = CustomFont.THEME_FONT_Medium(16)
            labelTextFieldTitle.textColor = Constants.color_themeColor
        }
    }
    
    @IBOutlet weak var textfiled: UITextField!{
        didSet{
            textfiled.layer.cornerRadius = 8.0
            textfiled.layer.borderWidth = 1.0
            textfiled.layer.borderColor = UIColor.lightGray.cgColor
            textfiled.font = CustomFont.THEME_FONT_Book(14)
            textfiled.textColor = Constants.color_DarkGrey
            textfiled.setLeftPadding(12)
            textfiled.setRightPadding(12)
        }
    }
    
    @IBOutlet var buttonDropDown: UIButton!
    
    @IBOutlet var labelMaxLimit: UILabel! {
        didSet {
            labelMaxLimit.text = Constants_Message.activity_title_max_limit
            labelMaxLimit.font = CustomFont.THEME_FONT_Medium(13)
            labelMaxLimit.textColor = Constants.color_MediumGrey
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
