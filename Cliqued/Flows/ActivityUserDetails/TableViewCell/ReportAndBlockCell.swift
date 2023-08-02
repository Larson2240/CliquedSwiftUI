//
//  ReportAndBlockCell.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit

class ReportAndBlockCell: UITableViewCell {

    @IBOutlet weak var buttonReportUser: UIButton!{
        didSet {
            buttonReportUser.setTitle(Constants.btn_reportUser, for: .normal)
            buttonReportUser.titleLabel?.font = CustomFont.THEME_FONT_Bold(20)
            buttonReportUser.setTitleColor(Constants.color_themeColor, for: .normal)
        }
    }
    @IBOutlet weak var buttonBlockUser: UIButton!{
        didSet {
            buttonBlockUser.setTitle(Constants.btn_blockUser, for: .normal)
            buttonBlockUser.titleLabel?.font = CustomFont.THEME_FONT_Bold(20)
            buttonBlockUser.setTitleColor(Constants.color_themeColor, for: .normal)
        }
    }
    
    @IBOutlet weak var constraintBlockButtonBottom: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
