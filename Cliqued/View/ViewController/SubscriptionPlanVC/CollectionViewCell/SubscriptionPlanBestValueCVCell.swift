//
//  SubscriptionPlanCVCell.swift
//  Cliqued
//
//  Created by C211 on 28/02/23.
//

import UIKit

class SubscriptionPlanBestValueCVCell: UICollectionViewCell {
    @IBOutlet weak var viewMain: UIView!{
        didSet {
            viewMain.layer.cornerRadius = 8.0
            viewMain.backgroundColor = Constants.color_themeColor
        }
    }
    
    @IBOutlet weak var labelBestValueTitle: UILabel!{
        didSet {
            labelBestValueTitle.text = Constants.label_bestValueTitle
            labelBestValueTitle.font = CustomFont.THEME_FONT_Medium(14)
            labelBestValueTitle.textColor = Constants.color_white
        }
    }
    
    @IBOutlet weak var viewSubview: UIView!{
        didSet {
            viewSubview.layer.cornerRadius = 8.0
            viewSubview.backgroundColor = Constants.color_white
        }
    }
    
    @IBOutlet weak var labelMonthValue: UILabel!{
        didSet {
            labelMonthValue.text = "0"
            labelMonthValue.font = CustomFont.THEME_FONT_Medium(24)
            labelMonthValue.textColor = Constants.color_themeColor
        }
    }
    
    @IBOutlet weak var labelMonthTitle: UILabel!{
        didSet {
            labelMonthTitle.text = Constants.label_monthTitle
            labelMonthTitle.font = CustomFont.THEME_FONT_Medium(11)
            labelMonthTitle.textColor = Constants.color_DarkGrey
        }
    }
    
    @IBOutlet weak var labelPlanPrice: UILabel!{
        didSet {
            labelPlanPrice.font = CustomFont.THEME_FONT_Medium(11)
            labelPlanPrice.textColor = Constants.color_DarkGrey
        }
    }
    
    @IBOutlet weak var labelPlanName: UILabel!{
        didSet {
            labelPlanName.font = CustomFont.THEME_FONT_Bold(13)
            labelPlanName.textColor = Constants.color_DarkGrey
        }
    }
    
    @IBOutlet weak var imageviewdotedline: UIImageView!
    @IBOutlet weak var constraintSubviewTop: NSLayoutConstraint!
    @IBOutlet weak var constraintSubviewTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintSubviewLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintSubviewBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelPlanName.adjustsFontSizeToFitWidth = true
        labelPlanName.minimumScaleFactor = 0.5
    }
    
    //MARK: Setup Normal Plan Cell UI
    func setupNormalPlanCell() {
        viewMain.backgroundColor = .clear
        labelBestValueTitle.isHidden = true
        viewSubview.backgroundColor = .clear
        viewSubview.layer.borderColor = Constants.color_themeColor.cgColor
        viewSubview.layer.borderWidth = 1.0
        constraintSubviewTop.constant = 14
        constraintSubviewLeading.constant = 0.0
        constraintSubviewTrailing.constant = 0.0
        constraintSubviewBottom.constant = 0.0
    }
    
    //MARK: Setup Best Value Plan Cell UI
    func setupBestValuePlanCell() {
        viewMain.backgroundColor = Constants.color_themeColor
        labelBestValueTitle.isHidden = false
        viewSubview.backgroundColor = Constants.color_white
        constraintSubviewTop.constant = 25
        constraintSubviewLeading.constant = 4.0
        constraintSubviewTrailing.constant = 4.0
        constraintSubviewBottom.constant = 4.0
    }
}
