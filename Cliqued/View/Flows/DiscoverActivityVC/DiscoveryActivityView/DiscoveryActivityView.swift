//
//  InterestUserActivityView.swift
//  Cliqued
//
//  Created by C211 on 21/02/23.
//

import UIKit

class DiscoveryActivityView: UIView {
    
    //MARK: IBOutlet
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageview: UIImageView!{
        didSet {
            imageview.layer.cornerRadius =  50.0
        }
    }
    @IBOutlet weak var labelActivityName: UILabel!{
        didSet {
            labelActivityName.font = CustomFont.THEME_FONT_Bold(19)
            labelActivityName.textColor = Constants.color_white
        }
    }
    @IBOutlet weak var labelCategoryName: UILabel!{
        didSet {
            labelCategoryName.font = CustomFont.THEME_FONT_Bold(19)
            labelCategoryName.textColor = Constants.color_white
        }
    }
    @IBOutlet weak var buttonInfo: UIButton!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var buttonDislike: UIButton!
    
    @IBOutlet weak var imageviewActivityOwner: UIImageView!{
        didSet {
            imageviewActivityOwner.layer.cornerRadius = imageviewActivityOwner.frame.size.height / 2
            imageviewActivityOwner.layer.borderWidth = 2.0
            imageviewActivityOwner.layer.borderColor = Constants.color_themeColor.cgColor
        }
    }
    
    @IBOutlet weak var buttonActivityOwnerInfo: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DiscoveryActivityView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = .clear
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addGradientOverleyOnImageview(imageView: imageview, gradientHeight: 0.7)
    }
}
