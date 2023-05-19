//
//  LicenseLibraryNameCell.swift
//  Cliqued
//
//  Created by C211 on 27/04/23.
//

import UIKit

class LicenseLibraryNameCell: UITableViewCell {

    @IBOutlet weak var labelLibraryName: UILabel!{
        didSet {
            labelLibraryName.font = CustomFont.THEME_FONT_Medium(15)
            labelLibraryName.textColor = Constants.color_DarkGrey
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
