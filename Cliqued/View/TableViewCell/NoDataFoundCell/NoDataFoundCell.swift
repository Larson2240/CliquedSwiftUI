//
//  NoDataFoundCell.swift
//  Cliqued
//
//  Created by C211 on 07/02/23.
//

import UIKit

class NoDataFoundCell: UITableViewCell {

    @IBOutlet weak var labelNoDataFound: UILabel!{
        didSet {
            labelNoDataFound.font = CustomFont.THEME_FONT_Medium(14)
            labelNoDataFound.textColor = Constants.color_MediumGrey
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
