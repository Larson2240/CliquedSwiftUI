//
//  LocationDistanceCell.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit
import StepSlider

class LocationDistanceCell: UITableViewCell {

    @IBOutlet weak var labelDescription: UILabel!{
        didSet {
            labelDescription.text = Constants.label_setLocationScreenDescription
            labelDescription.font = CustomFont.THEME_FONT_Book(14)
            labelDescription.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var sliderDistance: StepSlider!{
        didSet {
            sliderDistance.labelFont = CustomFont.THEME_FONT_Regular(10)
            sliderDistance.labelColor = Constants.color_DarkGrey
            sliderDistance.sliderCircleColor = Constants.color_themeColor
            sliderDistance.trackColor = Constants.color_MediumGrey
            sliderDistance.labels = ["5km","10km","50km","100km","200km"]
        }
    }
    
    var arrayOfDistance = [String]()
    var callbackForSetDefaultDistance: ((_ prefId: String, _ distId: String) ->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupSliderData()
    }
    
    //MARK: Setup slider value
    func setupSliderData() {
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfTypeOption = [TypeOptions]()
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == PreferenceTypeIds.distance}) ?? []
        if arrayOfPreference.count > 0 {
            arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
            if arrayOfTypeOption.count > 0 {
                for i in arrayOfTypeOption {
                    if let DistanceValue = i.title {
                        arrayOfDistance.append("\(DistanceValue)km")
                    }
                    
                }
            }
        }
        if arrayOfDistance.count > 0 {
            sliderDistance.labels.removeAll()
            sliderDistance.labels = arrayOfDistance
        }
    }
}
