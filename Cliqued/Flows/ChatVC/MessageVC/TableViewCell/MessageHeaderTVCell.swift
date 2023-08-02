//
//  MessageHeaderTVCell.swift
//  SwapItSports
//
//  Created by C100-132 on 05/08/22.
//

import UIKit

class MessageHeaderTVCell: UITableViewCell {
       
    @IBOutlet var labelDate: UILabel! {
        didSet {
            labelDate.font = CustomFont.THEME_FONT_Book(14)
            labelDate.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet var viewDate: UIView! {
        didSet {
            viewDate.layer.cornerRadius = 15
            viewDate.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
