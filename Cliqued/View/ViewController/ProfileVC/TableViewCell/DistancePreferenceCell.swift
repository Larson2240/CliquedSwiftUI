//
//  DistancePreferenceCell.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit
import StepSlider

class DistancePreferenceCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!{
        didSet {
            labelTitle.text = Constants.label_distancePreference
            labelTitle.textColor = Constants.color_themeColor
            labelTitle.font = CustomFont.THEME_FONT_Medium(14)
        }
    }
    @IBOutlet weak var sliderDistance: StepSlider!{
        didSet {
            sliderDistance.labelFont = CustomFont.THEME_FONT_Regular(10)
            sliderDistance.labelColor = Constants.color_DarkGrey
            sliderDistance.sliderCircleColor = Constants.color_themeColor
            sliderDistance.trackColor = Constants.color_MediumGrey
        }
    }
    var arrayOfDistance = [String]()
    var distancePreference: String?
    private let preferenceTypeIds = PreferenceTypeIds()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSliderData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Setup slider value
    func setupSliderData() {
        sliderDistance.labels = ["5km","10km","50km","100km","200km"]
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfTypeOption = [TypeOptions]()
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == preferenceTypeIds.distance}) ?? []
        if arrayOfPreference.count > 0 {
            arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
            if arrayOfTypeOption.count > 0 {
                for i in arrayOfTypeOption {
                    arrayOfDistance.append("\(i.title ?? "")km")
                }
            }
        }
        if arrayOfDistance.count > 0 {
            sliderDistance.labels = arrayOfDistance
        }
    }
}
