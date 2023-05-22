//
//  SubscriptionNormalPlanCVCell.swift
//  Cliqued
//
//  Created by C211 on 02/03/23.
//

import UIKit

class SubscriptionNormalPlanCVCell: UICollectionViewCell {
    @IBOutlet weak var viewMain: UIView!{
        didSet {
            viewMain.layer.cornerRadius = 8.0
            viewMain.backgroundColor = .clear
            viewMain.layer.borderColor = Constants.color_themeColor.cgColor
            viewMain.layer.borderWidth = 1.0
            viewMain.skeletonCornerRadius = 8.0
            viewMain.showAnimatedGradientSkeleton()
        }
    }
    
    @IBOutlet weak var labelMonthValue: UILabel! {
        didSet {
            labelMonthValue.text = "1"
            labelMonthValue.font = CustomFont.THEME_FONT_Medium(24)
            labelMonthValue.textColor = Constants.color_themeColor
        }
    }
    
    @IBOutlet weak var labelMonthTitle: UILabel! {
        didSet {
            labelMonthTitle.text = "Month"
            labelMonthTitle.font = CustomFont.THEME_FONT_Medium(11)
            labelMonthTitle.textColor = Constants.color_DarkGrey
        }
    }
    
    @IBOutlet weak var labelPlanPrice: UILabel! {
        didSet {
            labelPlanPrice.text = "CHF 108"
            labelPlanPrice.font = CustomFont.THEME_FONT_Medium(11)
            labelPlanPrice.textColor = Constants.color_DarkGrey
        }
    }
    
    @IBOutlet weak var labelPlanName: UILabel! {
        didSet {
            labelPlanName.text = "CHF 9/month"
            labelPlanName.font = CustomFont.THEME_FONT_Bold(13)
            labelPlanName.textColor = Constants.color_DarkGrey
        }
    }
    
    @IBOutlet weak var imageviewdotedline: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelPlanName.adjustsFontSizeToFitWidth = true
        labelPlanName.minimumScaleFactor = 0.5
    }
    
    func hideAnimation() {
        viewMain.hideSkeleton()
        labelPlanName.isHidden = false
        labelMonthTitle.isHidden = false
        labelMonthValue.isHidden = false
        labelPlanPrice.isHidden = false
        imageviewdotedline.isHidden = false
    }
}
