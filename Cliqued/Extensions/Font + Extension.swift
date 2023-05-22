//
//  Font + Extension.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 21.05.2023.
//

import SwiftUI

extension Font {
    static func themeBold(_ size: CGFloat) -> Font {
        .custom("Rationell-Bold", size: size)
    }
    
    static func themeBlack(_ size: CGFloat) -> Font {
        .custom("Rationell-Black", size: size)
    }
    
    static func themeBook(_ size: CGFloat) -> Font {
        .custom("Rationell-Book", size: size)
    }
    
    static func themeMedium(_ size: CGFloat) -> Font {
        .custom("Rationell-Medium", size: size)
    }
    
    static func themeRegular(_ size: CGFloat) -> Font {
        .custom("Rationell-Regular", size: size)
    }
    
    static func themeLight(_ size: CGFloat) -> Font {
        .custom("Rationell-Light", size: size)
    }
    
    static let bold = "Rationell-Bold"
    static let black = "Rationell-Black"
    static let book = "Rationell-Book"
    static let medium = "Rationell-Medium"
    static let regular = "Rationell-Regular"
    static let light = "Rationell-Light"
}
