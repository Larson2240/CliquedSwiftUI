//
//  CGSize + Extension.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 23.05.2023.
//

import CoreGraphics

extension CGSize {
    var hypot: CGFloat {
        CoreGraphics.hypot(width, height)
    }
}
