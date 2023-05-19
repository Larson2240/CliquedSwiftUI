//
//  SafeAreaView.swift
//  Cliqued
//
//  Created by C211 on 10/01/23.
//

import UIKit

class SafeAreaView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.frame = self.bounds
        self.backgroundColor = .clear
        self.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
}
