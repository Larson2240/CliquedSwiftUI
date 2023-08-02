//
//  UserProfileCVC.swift
//  Cliqued
//
//  Created by C100-132 on 28/01/23.
//

import UIKit

class UserProfileCVC: UICollectionViewCell {
    
    @IBOutlet var blurView: UIVisualEffectView! {
        didSet {
            blurView.layer.cornerRadius = 10.0
            blurView.layer.masksToBounds = true
        }
    }
    @IBOutlet var labelInterestedPeople: UILabel! {
        didSet {
            labelInterestedPeople.layer.cornerRadius = labelInterestedPeople.frame.height / 2
            labelInterestedPeople.layer.masksToBounds = true
            labelInterestedPeople.font = CustomFont.THEME_FONT_Bold(13)
        }
    }
    @IBOutlet var imageProfile: UIImageView! {
        didSet {
            imageProfile.layer.cornerRadius = 10.0
            imageProfile.layer.masksToBounds = true
            imageProfile.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet var viewProfile: UIView! {
        didSet {
            viewProfile.layer.cornerRadius = 10.0
            viewProfile.layer.masksToBounds = true
            viewProfile.showAnimatedGradientSkeleton()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func hideAnimation() {
        viewProfile.hideSkeleton()
        imageProfile.hideSkeleton()
        labelInterestedPeople.isHidden = false
    }
}
