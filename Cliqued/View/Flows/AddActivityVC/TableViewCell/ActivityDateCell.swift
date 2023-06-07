//
//  ActivityDateCell.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit

class ActivityDateCell: UITableViewCell {

    @IBOutlet weak var labelDateTitle: UILabel!{
        didSet {
            labelDateTitle.font = CustomFont.THEME_FONT_Medium(16)
            labelDateTitle.textColor = Constants.color_themeColor
        }
    }

    @IBOutlet weak var datepicker: UIDatePicker!{
        didSet {
            datepicker.layer.cornerRadius = 10.0
            datepicker.layer.borderWidth = 0.5
            datepicker.layer.borderColor = UIColor.gray.cgColor
            datepicker.backgroundColor = .lightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDatePicker()
    }
    
    //MARK: Setup Date Picker
    func setupDatePicker() {
        let calendar = Calendar(identifier: .gregorian)
        
        datepicker?.date = Date()
        datepicker?.locale = .current
        datepicker?.datePickerMode = .date
        datepicker?.minimumDate = Calendar.current.date(byAdding: .month, value: 0, to: Date())
//        datepicker?.maximumDate = Calendar.current.date(byAdding: .month, value: 2, to: Date())
        
        if #available(iOS 13.4, *) {
            datepicker?.preferredDatePickerStyle = .wheels
        }
    }
}
