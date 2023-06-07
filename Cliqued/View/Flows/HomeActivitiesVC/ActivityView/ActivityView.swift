//
//  ActivityView.swift
//  Cliqued
//
//  Created by C211 on 18/01/23.
//

import UIKit

class ActivityView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageview: UIImageView!{
        didSet {
            imageview.layer.cornerRadius =  50.0
        }
    }
    
    @IBOutlet weak var labelUserNameAndAge: UILabel!{
        didSet {
            labelUserNameAndAge.font = CustomFont.THEME_FONT_Bold(19)
            labelUserNameAndAge.textColor = Constants.color_white
        }
    }
    @IBOutlet weak var labelLocationDistance: UILabel!{
        didSet {
            labelLocationDistance.font = CustomFont.THEME_FONT_Bold(19)
            labelLocationDistance.textColor = Constants.color_white
        }
    }
    @IBOutlet weak var buttonUserInfo: UIButton!
    @IBOutlet weak var buttonUndo: UIButton!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var buttonDislike: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ActivityView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = .clear
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addGradientOverleyOnImageview(imageView: imageview, gradientHeight: 0.7)
    }
}
