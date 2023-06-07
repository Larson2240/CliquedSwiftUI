//
//  PlanTermsConditionCell.swift
//  Cliqued
//
//  Created by C211 on 20/02/23.
//

import UIKit

class PlanTermsConditionCell: UITableViewCell {

    @IBOutlet weak var labelTermsText: UILabel!{
        didSet{
            labelTermsText.text = Constants.label_subscriptionTerms
            labelTermsText.font = CustomFont.THEME_FONT_Medium(14)
            labelTermsText.textColor = Constants.color_DarkGrey
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
