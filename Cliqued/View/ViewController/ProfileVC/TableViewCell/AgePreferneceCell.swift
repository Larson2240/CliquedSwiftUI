//
//  AgePreferneceCell.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit
import RangeSeekSlider

class AgePreferneceCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!{
        didSet {
            labelTitle.text = Constants.label_agePreference
            labelTitle.textColor = Constants.color_themeColor
            labelTitle.font = CustomFont.THEME_FONT_Medium(14)
        }
    }
    
    @IBOutlet weak var seekbarAge: RangeSeekSlider!
    
    var arrayOfPreference = [PreferenceClass]()
    var arrayOfSubType = [SubTypes]()
    var arrayOfTypeOptionStartAge = [TypeOptions]()
    var arrayOfTypeOptionEndAge = [TypeOptions]()
    
    var startAgeId = ""
    var startAgePrefId = ""
    var endAgeId = ""
    var endAgePrefId = ""
    
    var selectedMinimumValue = 0.0
    var selectedMaximumValue = 0.0
    
    var callbackForAgePreferenceValue: ((_ ageStartId: String, _ ageStartPrefId: String, _ ageEndId: String, _ ageEndPrefId: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seekbarAge.delegate = self
        setupAgeRangeBar()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupAgeRangeBar() {
        var minSeekBarValue = "0"
        var maxSeekBarValue = "0"
        
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == PreferenceTypeIds.age}) ?? []
        if arrayOfPreference.count > 0 {
            arrayOfSubType = arrayOfPreference[0].subTypes ?? []
            if arrayOfSubType.count > 0 {
                let subTypesData = arrayOfSubType.filter({$0.typesOfPreference == PreferenceTypeIds.age_start})
                arrayOfTypeOptionStartAge = subTypesData[0].typeOptions ?? []
                if arrayOfTypeOptionStartAge.count > 0 {
                    minSeekBarValue = arrayOfTypeOptionStartAge.first?.title ?? "0"
                }
                
                let subTypesDataEndAge = arrayOfSubType.filter({$0.typesOfPreference == PreferenceTypeIds.age_end})
                arrayOfTypeOptionEndAge = subTypesDataEndAge[0].typeOptions ?? []
                
                if arrayOfTypeOptionEndAge.count > 0 {
                    maxSeekBarValue = arrayOfTypeOptionEndAge.last?.title ?? "0"
                }
            }
        }
        
        seekbarAge.minValue = Double(minSeekBarValue) ?? 0.0
        seekbarAge.maxValue = Double(maxSeekBarValue) ?? 0.0
        seekbarAge.step = 5
        seekbarAge.lineHeight = 3.5
        seekbarAge.handleColor = Constants.color_themeColor
        seekbarAge.colorBetweenHandles = Constants.color_themeColor
        seekbarAge.minLabelColor = Constants.color_DarkGrey
        seekbarAge.maxLabelColor = Constants.color_DarkGrey
        seekbarAge.minLabelFont = CustomFont.THEME_FONT_Medium(12)!
        seekbarAge.maxLabelFont = CustomFont.THEME_FONT_Medium(12)!
    }
    
}
extension AgePreferneceCell: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        print("didChange")
        print(minValue)
        print(maxValue)
        self.selectedMinimumValue = minValue
        self.selectedMaximumValue = maxValue
        
        if arrayOfTypeOptionStartAge.count > 0 {
            for mydata in arrayOfTypeOptionStartAge {
                if let strToNum1 = NumberFormatter().number(from: mydata.title ?? "") {
                    let startAge = CGFloat(truncating: strToNum1)
                    if startAge == self.selectedMinimumValue {
                        startAgeId = mydata.id?.description ?? ""
                        startAgePrefId = mydata.preferenceId?.description ?? ""
                    }
                }
            }
        }
        
        if arrayOfTypeOptionEndAge.count > 0 {
            for mydata in arrayOfTypeOptionEndAge {
                if let strToNum1 = NumberFormatter().number(from: mydata.title ?? "") {
                    let endAge = CGFloat(truncating: strToNum1)
                    if endAge == self.selectedMaximumValue {
                        endAgeId = mydata.id?.description ?? ""
                        endAgePrefId = mydata.preferenceId?.description ?? ""
                    }
                }
            }
        }
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
        print(slider.selectedMinValue)
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
        print(slider.selectedMaxValue)
        callbackForAgePreferenceValue?(startAgeId, startAgePrefId, endAgeId, endAgePrefId)
    }
}
