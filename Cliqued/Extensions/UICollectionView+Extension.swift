//
//  UICollectionView+Extension.swift
//  Bubbles
//
//  Created by C100-107 on 26/05/20.
//  Copyright © 2020 C100-107. All rights reserved.
//


import UIKit

extension UICollectionView {
    func registerNib(nibNames: [String]) {
        for nibName in nibNames {
            register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
        }
    }
}

extension UICollectionViewCell {
       
    static var identifier: String {
        return (self.description().split(separator: ".").last?.description) ?? ""
    }

}

