//
//  NavigationView.swift
//  clickapp
//
//  Created by C211 on 17/03/22.
//
// MARK: Description - This UIView file contains the UIDesign of UINavigationBar.

import UIKit

class UINavigationViewClass: UIView {
    
    //MARK: IBOutlet
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelNavigationTitle: UILabel! {
        didSet {
            labelNavigationTitle.font = CustomFont.THEME_FONT_Bold(16)
            labelNavigationTitle.textColor = Constants.color_NavigationBarText
            labelNavigationTitle.adjustsFontSizeToFitWidth = true
            labelNavigationTitle.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var constraintLabelHorizontal: NSLayoutConstraint!
    
    @IBOutlet weak var buttonSkip: UIButton!{
        didSet {
            buttonSkip.setTitle(Constants.btn_skip, for: .normal)
            buttonSkip.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonSkip.setTitleColor(Constants.color_DarkGrey, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NavigationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = .clear
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
}
