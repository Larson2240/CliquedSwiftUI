//
//  SubActivityCell.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class SubActivityCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!{
        didSet {
            viewMain.layer.cornerRadius = 8.0
        }
    }
    
    @IBOutlet weak var labelSubActivityTitle: UILabel!{
        didSet {
            labelSubActivityTitle.font = CustomFont.THEME_FONT_Medium(15)
            labelSubActivityTitle.textColor = Constants.color_DarkGrey
            labelSubActivityTitle.backgroundColor = Constants.color_GreyUnselectedBkg
            labelSubActivityTitle.layer.cornerRadius = 8.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8.0
    }

}
