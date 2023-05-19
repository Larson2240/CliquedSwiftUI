//
//  TextViewCell.swift
//  Cliqued
//
//  Created by C211 on 11/04/23.
//

import UIKit

class TextViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!{
        didSet {
            labelTitle.font = CustomFont.THEME_FONT_Medium(16)
            labelTitle.textColor = Constants.color_themeColor
        }
    }
    @IBOutlet weak var labelValue: UILabelPadding!{
        didSet{
            labelValue.layer.cornerRadius = 8.0
            labelValue.layer.borderWidth = 1.0
            labelValue.layer.borderColor = UIColor.lightGray.cgColor
            labelValue.font = CustomFont.THEME_FONT_Book(14)
            labelValue.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonClick: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
