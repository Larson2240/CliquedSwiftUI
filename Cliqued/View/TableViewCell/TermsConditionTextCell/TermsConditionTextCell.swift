//
//  TermsConditionTextCell.swift
//  Cliqued
//
//  Created by C211 on 13/01/23.
//

import UIKit

class TermsConditionTextCell: UITableViewCell {

    @IBOutlet weak var labelTermsText: UILabel!{
        didSet {
            labelTermsText.text = Constants.label_termsMessage
            labelTermsText.font = CustomFont.THEME_FONT_Regular(15)
            labelTermsText.textColor = Constants.color_MediumGrey
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
