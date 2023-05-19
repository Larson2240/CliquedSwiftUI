//
//  SocialLoginOptionCell.swift
//  Cliqued
//
//  Created by C211 on 12/01/23.
//

import UIKit

class SocialLoginOptionCell: UITableViewCell {

    @IBOutlet weak var buttonApple: UIButton!
    @IBOutlet weak var buttonFacebook: UIButton!
    @IBOutlet weak var buttonGoogle: UIButton!
    
    @IBOutlet weak var buttonDontHaveAccount: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
