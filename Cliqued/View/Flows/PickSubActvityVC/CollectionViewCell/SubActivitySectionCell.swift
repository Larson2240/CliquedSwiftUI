//
//  SubActivitySectionCell.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class SubActivitySectionCell: UICollectionViewCell {

    @IBOutlet weak var imageviewSection: UIImageView!
    @IBOutlet weak var labelSectionTitle: UILabel!{
        didSet {
            labelSectionTitle.font = CustomFont.THEME_FONT_Medium(14)
            labelSectionTitle.textColor = Constants.color_DarkGrey
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
