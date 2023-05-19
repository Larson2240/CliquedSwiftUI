//
//  ActivityCVCell.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class ActivityCVCell: UICollectionViewCell {

    
    @IBOutlet weak var viewMain: UIView!{
        didSet {
            viewMain.layer.cornerRadius = 8.0
            viewMain.backgroundColor = .clear
        }
    }
    @IBOutlet weak var imageviewActivity: UIImageView!{
        didSet {
            imageviewActivity.layer.cornerRadius = 8.0
        }
    }
    @IBOutlet weak var labelActivityName: UILabel!{
        didSet {
            labelActivityName.font = CustomFont.THEME_FONT_Medium(14)
            labelActivityName.textColor = Constants.color_white
        }
    }
    
    @IBOutlet weak var imageviewAlpha: UIImageView!{
        didSet {
            imageviewAlpha.layer.cornerRadius = 8.0
            imageviewAlpha.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        }
    }
    
    @IBOutlet weak var imageviewSelectedIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageviewAlpha.isHidden = true
        imageviewSelectedIcon.isHidden = true
    }

}
