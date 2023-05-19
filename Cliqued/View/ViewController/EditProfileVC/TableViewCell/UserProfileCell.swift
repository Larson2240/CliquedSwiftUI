//
//  UserProfileCell.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit
import SDWebImage

class UserProfileCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!{
        didSet {
            viewMain.layer.cornerRadius = 25.0
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.layer.cornerRadius = 25.0
        }
    }
    @IBOutlet weak var buttonEditProfileImage: UIButton!
    @IBOutlet weak var pagecontrol: UIPageControl!
    
    //MARK: Variable
    var arrayOfUserProfile = [UserProfileImages]()
    var callbackForViewMedia: ((_ isImageMedia: Bool, _ indexValue: Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    //MARK: - Class methods
    func setupCollectionView(){
        collectionView.backgroundColor = .clear
        registerCollectionCell()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func registerCollectionCell() {
        collectionView.registerNib(nibNames: [UserProfilePicturesCVCell.identifier])
        collectionView.reloadData()
    }
    
}
extension UserProfileCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width
        let cellHeight = collectionView.frame.size.height
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if arrayOfUserProfile.count > 0 {
            return arrayOfUserProfile.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if arrayOfUserProfile.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfilePicturesCVCell", for: indexPath) as! UserProfilePicturesCVCell
            
            if arrayOfUserProfile.count > 1 {
                pagecontrol.isHidden = false
                pagecontrol.numberOfPages = arrayOfUserProfile.count
            } else {
                pagecontrol.isHidden = true
            }
            
            let profileData = arrayOfUserProfile[indexPath.item]
            var mediaName = ""
            
            if profileData.mediaType == MediaType.image {
                mediaName = profileData.url ?? ""
                cell.imageviewVideoIcon.isHidden = true
            } else {
                mediaName = profileData.thumbnailUrl ?? ""
                cell.imageviewVideoIcon.isHidden = false
            }
            let strUrl = UrlProfileImage + mediaName
            let imageWidth = cell.imageviewUserProfile.frame.size.width
            let imageHeight = cell.imageviewUserProfile.frame.size.height
            let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
            let url = URL(string: baseTimbThumb)
            cell.imageviewUserProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageviewUserProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_detailpage"), options: .refreshCached, context: nil)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfilePicturesCVCell", for: indexPath) as! UserProfilePicturesCVCell
            pagecontrol.isHidden = true
            cell.imageviewUserProfile.image = UIImage(named: "placeholder_detailpage")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if arrayOfUserProfile.count > 0 {
            let profileData = arrayOfUserProfile[indexPath.item]
            if profileData.mediaType == MediaType.image {
                callbackForViewMedia?(true, indexPath.item)
            } else {
                callbackForViewMedia?(false, indexPath.item)
            }
        }
    }
    
    //MARK: PageControl Scrollview Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        pagecontrol.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
}
