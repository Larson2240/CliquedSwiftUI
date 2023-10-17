//
//  FavoriteActivityCell.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit
import SDWebImage

class FavoriteActivityCell: UITableViewCell {

    @IBOutlet weak var labelFavoriteActivityTitle: UILabel!{
        didSet {
            labelFavoriteActivityTitle.font = CustomFont.THEME_FONT_Medium(16)
            labelFavoriteActivityTitle.textColor = Constants.color_themeColor
        }
    }
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var buttonEditActivity: UIButton!
    
    var arrayOfFavoriteActivity = [Activity]()
    var arrayOfCategory = [UserInterestedCategory]()
    
    @IBOutlet weak var constraintCollectionviewHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
        registerCollectionCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func registerCollectionCell() {
        collectionview.registerNib(nibNames: [FavoriteActivityCVCell.identifier, NoDataFoundCVCell.identifier])
        collectionview.reloadData()
    }
}
extension FavoriteActivityCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrayOfFavoriteActivity.count > 0 {
            let cellWidth = (collectionView.frame.size.width) / 3
            let height = cellWidth + (cellWidth * 0.3)
            return CGSize(width: cellWidth, height: height)
        } else {
            let cellWidth = collectionView.frame.size.width
            let cellHeight = collectionView.frame.size.height
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayOfFavoriteActivity.count > 0 {
            return arrayOfFavoriteActivity.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if arrayOfFavoriteActivity.count > 0 {
            collectionView.isScrollEnabled = true
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteActivityCVCell", for: indexPath) as! FavoriteActivityCVCell
            cell.setLabelFontSizeAsPerScreen(size: 10)
            
            cell.hideAnimation()
            
            let favActivityData = arrayOfFavoriteActivity[indexPath.item]
            
            cell.labelActivityName.text = favActivityData.title
            
            cell.imageviewActivity.image = UIImage(named: favActivityData.title + "_image")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataFoundCVCell", for: indexPath) as! NoDataFoundCVCell
            cell.labelNoDataFound.text = Constants.label_noDataFound
            collectionView.isScrollEnabled = false
            return cell
        }
    }
}
