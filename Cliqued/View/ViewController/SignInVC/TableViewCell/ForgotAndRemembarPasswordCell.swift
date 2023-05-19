//
//  ForgotAndRemembarPasswordCell.swift
//  Cliqued
//
//  Created by C211 on 12/01/23.
//

import UIKit

class ForgotAndRemembarPasswordCell: UITableViewCell {
    
    @IBOutlet weak var buttonForgotPassword: UIButton!{
        didSet {
            buttonForgotPassword.setTitle(Constants.btn_forgotPassword, for: .normal)
            setupUIButton(btnName: buttonForgotPassword)
        }
    }

    @IBOutlet weak var buttonRemembarMe: UIButton!{
        didSet {
            buttonRemembarMe.setTitle(Constants.btn_rememberMe, for: .normal)
            setupUIButton(btnName: buttonRemembarMe)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //MARK: ButtonUI
    func setupUIButton(btnName: UIButton) {
        btnName.setTitleColor(Constants.color_DarkGrey, for: .normal)
        btnName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
        btnName.titleLabel?.adjustsFontSizeToFitWidth = true
        btnName.titleLabel?.minimumScaleFactor = 0.6
    }
    
}
