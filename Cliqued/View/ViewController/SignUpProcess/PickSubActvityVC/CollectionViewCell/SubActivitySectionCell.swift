//
//  SubActivitySectionCell.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class SubActivitySectionCell: UICollectionViewCell {

    @IBOutlet weak var buttonSectionImage: UIButton!{
        didSet {
            buttonSectionImage.layer.cornerRadius = buttonSectionImage.frame.size.height / 2
            buttonSectionImage.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var labelSectionTitle: UILabel!{
        didSet {
            labelSectionTitle.font = CustomFont.THEME_FONT_Medium(14)
            labelSectionTitle.textColor = Constants.color_DarkGrey
            labelSectionTitle.showAnimatedGradientSkeleton()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func hideAnimation() {
        buttonSectionImage.hideSkeleton()
        labelSectionTitle.hideSkeleton()
    }

}
