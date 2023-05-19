//
//  LocationDistanceCell.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit

class LocationDistanceCell: UITableViewCell {

    @IBOutlet weak var labelDescription: UILabel!{
        didSet {
            labelDescription.text = Constants.label_setLocationScreenDescription
            labelDescription.font = CustomFont.THEME_FONT_Book(14)
            labelDescription.textColor = Constants.color_DarkGrey
        }
    }
    
    @IBOutlet weak var sliderDistance: UISlider!{
        didSet {
            sliderDistance.thumbTintColor = Constants.color_themeColor
            sliderDistance.tintColor = Constants.color_themeColor
        }
    }
    
    @IBOutlet weak var label5km: UILabel!{
        didSet{
            label5km.text = "5km"
            label5km.textColor = Constants.color_DarkGrey
            label5km.font = CustomFont.THEME_FONT_Regular(10)
        }
    }
    @IBOutlet weak var label10km: UILabel!{
        didSet{
            label10km.text = "10km"
            label10km.textColor = Constants.color_DarkGrey
            label10km.font = CustomFont.THEME_FONT_Regular(10)
        }
    }
    @IBOutlet weak var label50km: UILabel!{
        didSet{
            label50km.text = "50km"
            label50km.textColor = Constants.color_DarkGrey
            label50km.font = CustomFont.THEME_FONT_Regular(10)
        }
    }
    @IBOutlet weak var label100km: UILabel!{
        didSet{
            label100km.text = "100km"
            label100km.textColor = Constants.color_DarkGrey
            label100km.font = CustomFont.THEME_FONT_Regular(10)
        }
    }
    @IBOutlet weak var label200km: UILabel!{
        didSet{
            label200km.text = "200km"
            label200km.textColor = Constants.color_DarkGrey
            label200km.font = CustomFont.THEME_FONT_Regular(10)
        }
    }
    
    let step: Float = 1
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
