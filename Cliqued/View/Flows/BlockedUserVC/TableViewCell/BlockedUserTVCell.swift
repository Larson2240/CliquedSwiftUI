//
//  BlockedUserTVCell.swift
//  Cliqued
//
//  Created by C100-132 on 10/02/23.
//

import UIKit

class BlockedUserTVCell: UITableViewCell {
    
    @IBOutlet var imageUserProfile: UIImageView! {
        didSet {
            imageUserProfile.layer.cornerRadius = imageUserProfile.frame.height / 2
            imageUserProfile.layer.masksToBounds = true
            imageUserProfile.skeletonCornerRadius = Float(imageUserProfile.frame.height / 2)
            imageUserProfile.showAnimatedGradientSkeleton()
        }
    }
    
    @IBOutlet var buttonUnblock: UIButton! {
        didSet {
            buttonUnblock.setTitle(Constants_Message.button_title_unblock, for: .normal)
            buttonUnblock.setTitleColor(Constants.color_themeColor, for: .normal)
            buttonUnblock.titleLabel?.font = CustomFont.THEME_FONT_Medium(12)
            
            buttonUnblock.skeletonCornerRadius = 10
            buttonUnblock.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet var labelUserName: UILabel! {
        didSet {
            labelUserName.font = CustomFont.THEME_FONT_Bold(15)
            labelUserName.textColor = Constants.color_NavigationBarText
            
            labelUserName.linesCornerRadius = 10
            labelUserName.skeletonTextNumberOfLines = 1
            labelUserName.showAnimatedGradientSkeleton()
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
    
    func hideAnimation() {
        imageUserProfile.hideSkeleton()
        buttonUnblock.hideSkeleton()
        labelUserName.hideSkeleton()
    }
    
}
