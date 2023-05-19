//
//  ActivityPhotoCell.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit

class ActivityPhotoCell: UITableViewCell {

    @IBOutlet weak var labelPhotoTitle: UILabel!{
        didSet {
            labelPhotoTitle.font = CustomFont.THEME_FONT_Medium(16)
            labelPhotoTitle.textColor = Constants.color_themeColor
        }
    }
    @IBOutlet weak var imageviewPhoto: UIImageView!{
        didSet {
            imageviewPhoto.layer.cornerRadius = 8.0
        }
    }
    
    @IBOutlet weak var labelPhotoDescription: UILabel!{
        didSet {
            labelPhotoDescription.text = Constants.label_photoDescription
            labelPhotoDescription.font = CustomFont.THEME_FONT_Book(16)
            labelPhotoDescription.textColor = Constants.color_MediumGrey
        }
    }
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonCancel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
