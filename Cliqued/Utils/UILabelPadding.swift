//
//  UILabelPadding.swift
//  Cliqued
//
//  Created by C211 on 11/04/23.
//

import UIKit

class UILabelPadding: UILabel {

    let padding = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 20)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
