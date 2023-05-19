//
//  UserProfilePicturesCVCell.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit

class UserProfilePicturesCVCell: UICollectionViewCell {

    @IBOutlet weak var imageviewUserProfile: UIImageView!
    @IBOutlet weak var imageviewVideoIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageviewVideoIcon.isHidden = true
        imageviewUserProfile.setGradientBackground(colorTop: .clear, colorBottom: UIColor.black,viewHeight:200, viewWidth: imageviewUserProfile.frame.width)
    }
}
