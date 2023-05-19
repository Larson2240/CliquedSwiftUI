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
            viewMain.layer.cornerRadius = 15.0
            viewMain.backgroundColor = .clear
            viewMain.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var imageviewActivity: UIImageView!{
        didSet {
            imageviewActivity.layer.cornerRadius = 15.0
            imageviewActivity.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var labelActivityName: UILabel!{
        didSet {
            labelActivityName.textColor = Constants.color_white
        }
    }
    
    @IBOutlet weak var imageviewAlpha: UIImageView!{
        didSet {
            imageviewAlpha.layer.cornerRadius = 15.0
            imageviewAlpha.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        }
    }
    
    @IBOutlet weak var imageviewSelectedIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageviewAlpha.isHidden = true
        imageviewSelectedIcon.isHidden = true
        imageviewActivity.setGradientBackground(colorTop: .clear, colorBottom: UIColor.black, viewHeight:200, viewWidth: imageviewActivity.frame.width)
    }

    func setLabelFontSizeAsPerScreen(size: CGFloat) {
        labelActivityName.font = CustomFont.THEME_FONT_Medium(size)
    }
    
    func hideAnimation() {
        viewMain.hideSkeleton()
        imageviewActivity.hideSkeleton()
        labelActivityName.isHidden = false
    }
}
