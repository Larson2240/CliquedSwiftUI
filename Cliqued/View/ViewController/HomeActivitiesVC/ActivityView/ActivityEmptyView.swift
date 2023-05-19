//
//  ActivityEmptyView.swift
//  Cliqued
//
//  Created by C211 on 14/02/23.
//

import UIKit

class ActivityEmptyView: UIView {
    
    @IBOutlet weak var labelNoCardsFound: UILabel!{
        didSet {
            labelNoCardsFound.font = CustomFont.THEME_FONT_Medium(14)
            labelNoCardsFound.textColor = Constants.color_MediumGrey
        }
    }
}
