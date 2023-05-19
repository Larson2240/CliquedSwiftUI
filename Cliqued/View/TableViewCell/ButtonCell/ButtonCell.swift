//
//  ButtonCell.swift
//  Cliqued
//
//  Created by C211 on 12/01/23.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var constraintButtonTop: NSLayoutConstraint!
    @IBOutlet weak var constraintButtonBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.titleLabel?.font = CustomFont.THEME_FONT_Bold(20)
        button.setTitleColor(Constants.color_white, for: .normal)
        button.backgroundColor = Constants.color_themeColor
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.masksToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.button.layer.cornerRadius = self.button.frame.height / 2
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
