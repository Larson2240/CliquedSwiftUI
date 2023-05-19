//
//  ReceiverTVCell.swift
//  SwapItSports
//
//  Created by C100-132 on 25/05/22.
//

import UIKit

class ReceiverTVCell: UITableViewCell {
   
    @IBOutlet var labelReceiverText: UILabel! {
        didSet {
            labelReceiverText.font = CustomFont.THEME_FONT_Book(14)
            labelReceiverText.textColor = Constants.color_white
        }
    }
    @IBOutlet var labelDateTime: UILabel! {
        didSet {
            labelDateTime.font = CustomFont.THEME_FONT_Medium(10)
            labelDateTime.textColor = Constants.color_message_time
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
