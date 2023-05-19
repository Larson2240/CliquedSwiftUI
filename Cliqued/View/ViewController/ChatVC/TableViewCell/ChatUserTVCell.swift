//
//  ChatUserTVCell.swift
//  Cliqued
//
//  Created by C100-132 on 28/01/23.
//

import UIKit

class ChatUserTVCell: UITableViewCell {
    
    @IBOutlet var labelUserName: UILabel! {
        didSet {
            labelUserName.font = CustomFont.THEME_FONT_Medium(14)
            labelUserName.textColor = Constants.color_chat_name
            
            labelUserName.lastLineFillPercent = 100
            labelUserName.linesCornerRadius = 10
            labelUserName.skeletonTextNumberOfLines = 1
            labelUserName.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet var labelMessage: UILabel! {
        didSet {
            labelMessage.font = CustomFont.THEME_FONT_Book(12)
            labelMessage.textColor = Constants.color_DarkGrey
            
            labelMessage.linesCornerRadius = 5
            labelMessage.skeletonTextNumberOfLines = 1
            labelMessage.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet var labelDate: UILabel! {
        didSet {
            labelDate.font = CustomFont.THEME_FONT_Regular(11)
            labelDate.textColor = Constants.color_DarkGrey
            
            labelDate.lastLineFillPercent = 100
            labelDate.linesCornerRadius = 10
            labelDate.skeletonTextNumberOfLines = 1
            labelDate.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet var imageUserProfile: UIImageView! {
        didSet {
            imageUserProfile.layer.cornerRadius = imageUserProfile.frame.height / 2
            imageUserProfile.layer.masksToBounds = true
            imageUserProfile.showAnimatedGradientSkeleton()
        }
    }    
    @IBOutlet var buttonUserProfile: UIButton!    
    @IBOutlet var imageMsgTypeWidthConstant: NSLayoutConstraint!
    @IBOutlet var imageMessageType: UIImageView!    
    @IBOutlet var labelMessageLeadingConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func hideAnimation() {
        labelUserName.hideSkeleton()
        labelMessage.hideSkeleton()
        labelDate.hideSkeleton()
        imageUserProfile.hideSkeleton()
    }
    
}
