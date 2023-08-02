//
//  YourActivityCVCell.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit

class YourActivityCVCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!{
        didSet {
            viewMain.layer.cornerRadius = 15.0
        }
    }
    @IBOutlet weak var imageviewActivity: UIImageView!{
        didSet {
            imageviewActivity.layer.cornerRadius = 15.0
            imageviewActivity.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var buttonInterestedCount: UIButton!{
        didSet {
            buttonInterestedCount.layer.cornerRadius = buttonInterestedCount.frame.size.height / 2
            buttonInterestedCount.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        }
    }
    @IBOutlet weak var buttonEditActivity: UIButton!
    @IBOutlet weak var labelSubCategory: UILabel!{
        didSet {
            labelSubCategory.font = CustomFont.THEME_FONT_Bold(12)
            labelSubCategory.textColor = Constants.color_white
        }
    }
    @IBOutlet weak var labelMainCategory: UILabel!{
        didSet {
            labelMainCategory.font = CustomFont.THEME_FONT_Medium(11)
            labelMainCategory.textColor = Constants.color_white
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonInterestedCount.isHidden = true
        imageviewActivity.setGradientBackground(colorTop: .clear, colorBottom: UIColor.black,viewHeight:250, viewWidth: imageviewActivity.frame.width)
    }
    
    func hideAnimation() {
        imageviewActivity.hideSkeleton()
        buttonInterestedCount.isHidden = false
        labelSubCategory.isHidden = false
        labelMainCategory.isHidden = false
        buttonEditActivity.isHidden = false
    }

}
