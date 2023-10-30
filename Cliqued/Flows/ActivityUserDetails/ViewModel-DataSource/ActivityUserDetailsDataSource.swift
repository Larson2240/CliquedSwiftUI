//
//  ActivityUserDetailsDataSource.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit
import SDWebImage
import SKPhotoBrowser
import AVKit
import AVFoundation

class ActivityUserDetailsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewController: ActivityUserDetailsVC
    private let tableView: UITableView
    private let collectionView: UICollectionView
    private let viewModel: ActivityUserDetailsViewModel
    private let mediaType = MediaType()
    
    enum enumActivityDetailsTableRow: Int, CaseIterable {
        case aboutme = 0
        case favoriteActivity
        case lookingFor
        case location
        case height
        case kids
        case smoking
        case buttonReportAndBlock
    }
    
    //MARK:- Init
    init(tableView: UITableView, collectionView: UICollectionView, viewModel: ActivityUserDetailsViewModel, viewController: ActivityUserDetailsVC) {
        self.viewController = viewController
        self.tableView = tableView
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init()
        setupTableView()
        setupCollectionView()
    }
    
    //MARK: - Class methods
    func setupTableView(){
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        registerTableCell()
    }
    func registerTableCell(){
        tableView.registerNib(nibNames: [AboutMeCell.identifier, FavoriteActivityCell.identifier,UserProfileCommonCell.identifier, ReportAndBlockCell.identifier])
        tableView.reloadData()
    }
    
    //MARK: - Class methods
    func setupCollectionView(){
        collectionView.backgroundColor = .clear
        registerCollectionCell()
    }
    
    func registerCollectionCell() {
        collectionView.registerNib(nibNames: [UserProfilePicturesCVCell.identifier])
        collectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enumActivityDetailsTableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumActivityDetailsTableRow(rawValue: indexPath.row)! {
        case .aboutme:
            let cell = tableView.dequeueReusableCell(withIdentifier: AboutMeCell.identifier) as! AboutMeCell
            cell.selectionStyle = .none
            if !viewModel.getAboutMe().isEmpty {
                cell.labelAboutMeText.text = viewModel.getAboutMe()
            } else {
                cell.labelAboutMeText.text = "-"
            }
            return cell
        case .favoriteActivity:
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteActivityCell.identifier) as! FavoriteActivityCell
            cell.selectionStyle = .none
            cell.buttonEditActivity.isHidden = true
            cell.labelFavoriteActivityTitle.text = Constants.label_favoriteActivities
            cell.arrayOfFavoriteActivity = viewModel.getFavoriteCategoryActivity()
            cell.collectionview.reloadData()
            let cellWidth = (cell.collectionview.frame.size.width) / 3
            let height = cellWidth + (cellWidth * 0.3)
            cell.constraintCollectionviewHeight.constant = height
            cell.layoutIfNeeded()
            return cell
        case .lookingFor:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileCommonCell.identifier) as! UserProfileCommonCell
            cell.selectionStyle = .none
            cell.imageviewIcon.image = UIImage(named: "ic_lookingfor")
            cell.labelTitle.text = Constants.label_lookingFor
            cell.labelValue.text = viewModel.getLookingFor()
            return cell
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileCommonCell.identifier) as! UserProfileCommonCell
            cell.selectionStyle = .none
            cell.imageviewIcon.image = UIImage(named: "ic_location_black")
            cell.labelTitle.text = Constants.label_location
            
            if let location = viewModel.getLocation() {
                cell.labelValue.text = "\(location.address), \(location.city ), \(location.state ), \(location.country), \(location.pincode)"
                cell.labelValue.text = "\(location.city), \(location.state)"
            } else {
                cell.labelValue.text = "-"
            }
            return cell
        case .height:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileCommonCell.identifier) as! UserProfileCommonCell
            cell.selectionStyle = .none
            cell.imageviewIcon.image = UIImage(named: "ic_height")
            cell.labelTitle.text = "\(Constants.label_height) \(Constants.label_heightInCm)"
            if viewModel.getHeight() != "0" {
                cell.labelValue.text = viewModel.getHeight()
            } else {
                cell.labelValue.text = "-"
            }
            return cell
        case .kids:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileCommonCell.identifier) as! UserProfileCommonCell
            cell.selectionStyle = .none
            cell.imageviewIcon.image = UIImage(named: "ic_kids")
            cell.labelTitle.text = Constants.label_kids
            if !viewModel.getKids().isEmpty {
                cell.labelValue.text = viewModel.getKids()
            } else {
                cell.labelValue.text = "No"
            }
            return cell
        case .smoking:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileCommonCell.identifier) as! UserProfileCommonCell
            cell.selectionStyle = .none
            cell.imageviewIcon.image = UIImage(named: "ic_smoking")
            cell.labelTitle.text = Constants.label_smoking
            if !viewModel.getSmoking().isEmpty {
                cell.labelValue.text = viewModel.getSmoking()
            } else {
                cell.labelValue.text = "No"
            }
            return cell
        case .buttonReportAndBlock:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReportAndBlockCell.identifier) as! ReportAndBlockCell
            cell.selectionStyle = .none
            
            if viewController.isFromOtherScreen || viewController.is_fromChatActivity {
                cell.constraintBlockButtonBottom.constant = 12
            } else {
                cell.constraintBlockButtonBottom.constant = 100
            }
            
            cell.buttonReportUser.tag = enumActivityDetailsTableRow.buttonReportAndBlock.rawValue
            cell.buttonBlockUser.tag = enumActivityDetailsTableRow.buttonReportAndBlock.rawValue
            cell.buttonReportUser.addTarget(self, action: #selector(btnReportUserClick(_:)), for: .touchUpInside)
            cell.buttonBlockUser.addTarget(self, action: #selector(btnBlockUserClick(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func btnReportUserClick(_ sender: UIButton) {
        let reportuservc = ReportUserVC.loadFromNib()
        reportuservc.reportedUserId = viewModel.getActivityUserId()
        viewController.navigationController?.pushViewController(reportuservc, animated: true)
    }
    
    @objc func btnBlockUserClick(_ sender: UIButton) {
        viewController.alertCustom(btnNo:Constants.btn_cancel, btnYes:Constants.btn_block, title: "", message: Constants.label_blockAlertMsg) {
            let activityUserId = self.viewModel.getActivityUserId()
            self.viewModel.callBlcokUserAPI(counterUserId: activityUserId)
        }
    }
}
extension ActivityUserDetailsDataSource: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width
        let cellHeight = collectionView.frame.size.height
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !viewModel.isCheckProfileImage() {
            return viewModel.getNumberOfUserProfile()
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !viewModel.isCheckProfileImage() {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfilePicturesCVCell", for: indexPath) as! UserProfilePicturesCVCell
            if viewModel.getNumberOfUserProfile() > 1 {
                viewController.pageviewcontrol.isHidden = false
                viewController.pageviewcontrol.numberOfPages = viewModel.getNumberOfUserProfile()
            } else {
                viewController.pageviewcontrol.isHidden = true
            }
            
            let profileData = viewModel.getUserProfileData(at: indexPath.item)
            var mediaName = ""
            
//            if profileData.mediaType == mediaType.image {
                mediaName = "https://api.cliqued.app" + profileData.url
                cell.imageviewVideoIcon.isHidden = true
//            } else {
//                mediaName = profileData.thumbnailUrl ?? ""
//                cell.imageviewVideoIcon.isHidden = false
//            }
            
            let url = URL(string: mediaName)
            cell.imageviewUserProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageviewUserProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_detailpage"), options: .refreshCached, context: nil)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfilePicturesCVCell", for: indexPath) as! UserProfilePicturesCVCell
            viewController.pageviewcontrol.isHidden = true
            cell.imageviewUserProfile.image = UIImage(named: "placeholder_detailpage")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !viewModel.isCheckProfileImage() {
            let profileData = viewModel.getUserProfileData(at: indexPath.item)
            
//            if profileData.mediaType == mediaType.image {
                var images = [SKPhotoProtocol]()
                for i in 0..<self.viewModel.getNumberOfUserProfile() {
//                    if self.viewModel.getUserProfileData(at: i).mediaType == mediaType.image {
                        let photo = SKPhoto.photoWithImageURL("https://api.cliqued.app" + (self.viewModel.getUserProfileData(at: i).url))
                        photo.shouldCachePhotoURLImage = true
                        images.append(photo)
//                    }
                }
                let browser = SKPhotoBrowser(photos: images)
                SKPhotoBrowserOptions.displayAction = false
                browser.initializePageIndex(indexPath.item)
                viewController.present(browser, animated: true, completion: {})
//            } else {
//                let videoURL = URL(string: UrlProfileImage + (profileData.url ?? ""))
//                let player = AVPlayer(url: videoURL! as URL)
//                let playerViewController = AVPlayerViewController()
//                playerViewController.player = player
//                viewController.present(playerViewController, animated: true) {
//                    playerViewController.player!.play()
//                }
//            }
        }
    }
    
    //MARK: PageControl Scrollview Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        viewController.pageviewcontrol.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
}
