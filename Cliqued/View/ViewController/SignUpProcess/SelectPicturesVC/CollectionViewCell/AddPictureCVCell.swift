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
            imageviewAddPlaceholder.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var buttonAddPicture: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
