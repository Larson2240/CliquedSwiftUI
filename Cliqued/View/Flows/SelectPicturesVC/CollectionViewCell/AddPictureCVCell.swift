//
//  AddPictureCVCell.swift
//  Cliqued
//
//  Created by C211 on 18/01/23.
//

import UIKit

class AddPictureCVCell: UICollectionViewCell {

    @IBOutlet weak var imageviewAddPlaceholder: UIImageView!{
        didSet {
            imageviewAddPlaceholder.layer.cornerRadius = 8.0
            imageviewAddPlaceholder.layer.borderWidth = 0.8
            imageviewAddPlaceholder.layer.borderColor = Constants.color_MediumGrey.cgColor
        }
    }
    
    @IBOutlet weak var buttonAddPicture: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
