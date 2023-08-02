//
//  SelectPictureCell.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit

class SelectPictureCell: UICollectionViewCell {

    @IBOutlet weak var imageview: UIImageView!{
        didSet {
            imageview.layer.cornerRadius = 8.0
            imageview.layer.borderWidth = 0.8
            imageview.layer.borderColor = Constants.color_MediumGrey.cgColor
        }
    }
    
    @IBOutlet weak var imageviewVideoIcon: UIImageView!
    
    @IBOutlet weak var buttonCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
