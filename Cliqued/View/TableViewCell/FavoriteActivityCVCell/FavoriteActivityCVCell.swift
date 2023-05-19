//
//  FavoriteActivityCVCell.swift
//  Cliqued
//
//  Created by C211 on 05/05/23.
//

import UIKit

class FavoriteActivityCVCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!{
        didSet {
            viewMain.layer.cornerRadius = 10.0
            viewMain.backgroundColor = .clear
            viewMain.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var imageviewActivity: UIImageView!{
        didSet {
            imageviewActivity.layer.cornerRadius = 10.0
            imageviewActivity.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var labelActivityName: UILabel!{
        didSet {
            labelActivityName.textColor = Constants.color_white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageviewActivity.setGradientBackground1(colorTop: .clear, colorBottom: UIColor.black, viewHeight:200, viewWidth: imageviewActivity.frame.width)
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
