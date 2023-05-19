//
//  SelectPictureCell.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit

class SelectPictureCell: UICollectionViewCell {

    @IBOutlet weak var imageview: UIImageView!{
        didSet {
            imageview.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var imageviewVideoIcon: UIImageView!
    
    @IBOutlet weak var buttonCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
