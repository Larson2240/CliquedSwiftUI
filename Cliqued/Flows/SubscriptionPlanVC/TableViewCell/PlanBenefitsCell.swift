//
//  PlanBenefitsCell.swift
//  Cliqued
//
//  Created by C211 on 20/02/23.
//

import UIKit

class PlanBenefitsCell: UITableViewCell {

    @IBOutlet weak var labelBenefitText1: UILabel!{
        didSet{
            labelBenefitText1.text = Constants.label_planBenefitText1
            labelBenefitText1.font = CustomFont.THEME_FONT_Medium(14)
            labelBenefitText1.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelBenefitText2: UILabel!{
        didSet{
            labelBenefitText2.text = Constants.label_planBenefitText2
            labelBenefitText2.font = CustomFont.THEME_FONT_Medium(14)
            labelBenefitText2.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelBenefitText3: UILabel!{
        didSet{
            labelBenefitText3.text = Constants.label_planBenefitText3
            labelBenefitText3.font = CustomFont.THEME_FONT_Medium(14)
            labelBenefitText3.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelBenefitText4: UILabel!{
        didSet{
            labelBenefitText4.text = Constants.label_planBenefitText4
            labelBenefitText4.font = CustomFont.THEME_FONT_Medium(14)
            labelBenefitText4.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelBenefitText5: UILabel!{
        didSet{
            labelBenefitText5.text = Constants.label_planBenefitText5
            labelBenefitText5.font = CustomFont.THEME_FONT_Medium(14)
            labelBenefitText5.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelBenefitText6: UILabel!{
        didSet{
            labelBenefitText6.text = Constants.label_planBenefitText6
            labelBenefitText6.font = CustomFont.THEME_FONT_Medium(14)
            labelBenefitText6.textColor = Constants.color_DarkGrey
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
