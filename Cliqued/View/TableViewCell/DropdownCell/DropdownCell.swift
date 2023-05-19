//
//  DropdownCell.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit

class DropdownCell: UITableViewCell {

    @IBOutlet weak var labelDropdownTitle: UILabel!{
        didSet {
            labelDropdownTitle.font = CustomFont.THEME_FONT_Medium(16)
            labelDropdownTitle.textColor = Constants.color_themeColor
        }
    }
    @IBOutlet weak var textfiledDropdown: UITextField!{
        didSet{
            textfiledDropdown.layer.cornerRadius = 8.0
            textfiledDropdown.layer.borderWidth = 1.0
            textfiledDropdown.layer.borderColor = UIColor.lightGray.cgColor
            textfiledDropdown.font = CustomFont.THEME_FONT_Book(14)
            textfiledDropdown.textColor = Constants.color_DarkGrey
            textfiledDropdown.setLeftPadding(12)
            textfiledDropdown.setRightPadding(18)
            textfiledDropdown.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var imageviewRightIcon: UIImageView!
    @IBOutlet weak var imageviewDropdownIcon: UIImageView!
    
    @IBOutlet weak var buttonDropdown: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
