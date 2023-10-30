//
//  YourActivitiesCell.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit
import SDWebImage

class YourActivitiesCell: UITableViewCell {

    @IBOutlet weak var labelYourActivitiesTitle: UILabel!{
        didSet {
            labelYourActivitiesTitle.font = CustomFont.THEME_FONT_Bold(16)
            labelYourActivitiesTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var buttonActivity: UIButton!
    @IBOutlet weak var imageviewLine: UIImageView!
    @IBOutlet weak var constraintCollectionHeight : NSLayoutConstraint!
    @IBOutlet var labelNoDataText: UILabel! {
        didSet {
            labelNoDataText.font = CustomFont.THEME_FONT_Medium(14)
            labelNoDataText.textColor = Constants.color_MediumGrey
        }
    }
    
    var callbackForButtonClick: ((_ isEditButton: Bool, _ isbuttonClick: Bool, _ selectedIndex: Int) -> Void)?
    var callbackForDidSelectClick: ((_ isbuttonClick: Bool, _ selectedIndex: Int) -> Void)?
    var arrMyActivities = [UserActivityClass]()
    var arrOtherActivities = [UserActivityClass]()
    var isDataLoad: Bool = false
    
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
        collectionview.registerNib(nibNames: [YourActivityCVCell.identifier])
        collectionview.reloadData()
    }
}
extension YourActivitiesCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.size.width - 10) / 3
        let height = cellWidth + (cellWidth * 0.6)
        return CGSize(width: cellWidth, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == enumActivitiesTableRow.yourActivities.rawValue {
            if isDataLoad {
                return arrMyActivities.count
            } else {
                return 4
            }
        } else {
            if isDataLoad {
                return arrOtherActivities.count
            } else {
                return 4
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == enumActivitiesTableRow.yourActivities.rawValue {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YourActivityCVCell.identifier, for: indexPath) as! YourActivityCVCell
            
            if isDataLoad {
                cell.hideAnimation()
            } else {
                isDataLoad = false
                cell.layoutIfNeeded()
                return cell
            }
            
            let obj = arrMyActivities[indexPath.item]
            
            cell.buttonInterestedCount.isHidden = false
            cell.buttonEditActivity.isHidden = false
            cell.buttonEditActivity.tag = indexPath.item
//            cell.buttonInterestedCount.setTitle("\(obj.interestedCount ?? 0)", for: .normal)
            
//            if obj.interestedCount != 0 {
//                cell.buttonInterestedCount.isHidden = false
//                cell.buttonInterestedCount.setTitle("\(obj.interestedCount ?? 0)", for: .normal)
//            } else {
//                cell.buttonInterestedCount.isHidden = true
//            }
            
            
            if obj.medias.count > 0 {
                let img = obj.medias[0]
                let url = URL(string: "https://api.cliqued.app" + img.url)
                
                cell.imageviewActivity.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imageviewActivity.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_activity"), options: .refreshCached, context: nil)
            } else {
                cell.imageviewActivity.image = UIImage(named: "placeholder_activity")
            }
            
            cell.labelMainCategory.text = obj.activityCategories.first
            cell.labelSubCategory.text = obj.title
            
            cell.buttonEditActivity.tag = indexPath.item
            cell.buttonEditActivity.addTarget(self, action: #selector(buttonEditActivityTap(_:)), for: .touchUpInside)
            
            cell.buttonInterestedCount.tag = indexPath.item
//            if obj.interestedCount != 0 {
//                cell.buttonInterestedCount.addTarget(self, action: #selector(buttonInterestedCountTap(_:)), for: .touchUpInside)
//            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YourActivityCVCell.identifier, for: indexPath) as! YourActivityCVCell
            
            if isDataLoad {
                cell.hideAnimation()
            } else {
                isDataLoad = false
                cell.layoutIfNeeded()
                return cell
            }
            
            let obj = arrOtherActivities[indexPath.item]
            
            cell.buttonInterestedCount.isHidden = true
            cell.buttonEditActivity.isHidden = true
            
            if obj.medias.count > 0 {
                let img = obj.medias[0]
                let url = URL(string: "https://api.cliqued.app" + img.url)
                
                cell.imageviewActivity.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imageviewActivity.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_activity"), options: .refreshCached, context: nil)
            } else {
                cell.imageviewActivity.image = UIImage(named: "placeholder_activity")
            }
            cell.labelMainCategory.text = obj.activityCategories.first
            cell.labelSubCategory.text = obj.title
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == enumActivitiesTableRow.yourActivities.rawValue {
            callbackForDidSelectClick?(true,indexPath.item)
        } else {
            callbackForDidSelectClick?(true,indexPath.item)
        }
    }
    
    //MARK: button Edit Activity Tap
    @objc func buttonEditActivityTap(_ sender: UIButton) {
        callbackForButtonClick?(true, true, sender.tag)
    }
    
    //MARK: button Interested Count Activity Tap
    @objc func buttonInterestedCountTap(_ sender: UIButton) {
        callbackForButtonClick?(false, true, sender.tag)
    }
}
