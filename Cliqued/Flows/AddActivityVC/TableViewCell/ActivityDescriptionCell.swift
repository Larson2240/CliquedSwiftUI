//
//  ActivityDescriptionCell.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit

class ActivityDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var labelTextViewTitle: UILabel!{
        didSet {
            labelTextViewTitle.font = CustomFont.THEME_FONT_Medium(16)
            labelTextViewTitle.textColor = Constants.color_themeColor
        }
    }
    @IBOutlet weak var textview: UITextView!{
        didSet{
            textview.layer.cornerRadius = 8.0
            textview.layer.borderWidth = 1.0
            textview.layer.borderColor = UIColor.lightGray.cgColor
            textview.font = CustomFont.THEME_FONT_Book(16)
            textview.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var constraintTextviewHeight: NSLayoutConstraint!
    @IBOutlet var labelMaxLimit: UILabel! {
        didSet {
            labelMaxLimit.text = Constants_Message.activity_description_max_limit
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
