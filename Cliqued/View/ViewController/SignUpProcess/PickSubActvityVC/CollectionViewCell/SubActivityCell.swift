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
            viewMain.showAnimatedGradientSkeleton()
        }
    }
    
    @IBOutlet weak var labelSubActivityTitle: UILabel!{
        didSet {
            labelSubActivityTitle.font = CustomFont.THEME_FONT_Medium(15)
            labelSubActivityTitle.textColor = Constants.color_DarkGrey
            labelSubActivityTitle.layer.cornerRadius = 8.0
            labelSubActivityTitle.showAnimatedGradientSkeleton()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8.0
        labelSubActivityTitle.adjustsFontSizeToFitWidth = true
        labelSubActivityTitle.minimumScaleFactor = 0.5
    }

    func selectedCategoryUI(viewName: UIView) {
        viewName.backgroundColor = Constants.color_GreenSelectedBkg
        labelSubActivityTitle.textColor = Constants.color_white
    }
    //MARK: UI Of Un-selected Button
    func unselectedCategoryUI(viewName: UIView) {
        viewName.backgroundColor = Constants.color_GreyUnselectedBkg
        labelSubActivityTitle.textColor = Constants.color_DarkGrey
    }
    
    func hideAnimation() {
        viewMain.hideSkeleton()
        labelSubActivityTitle.hideSkeleton()
        labelSubActivityTitle.isHidden = false
    }
}
