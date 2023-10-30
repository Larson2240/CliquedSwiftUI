//
//  ActivityDetailsDataSource.swift
//  Cliqued
//
//  Created by C211 on 24/03/23.
//

import SwiftUI
import SDWebImage
import MapKit
import CoreLocation

class ActivityDetailsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
    private let viewController: ActivityDetailsVC
    private let tableView: UITableView
    private let viewModel: ActivityDetailsViewModel
    private let viewModel1: InterestedActivityViewModel
    private let interestedActivityStatus = InterestedActivityStatus()
    
    enum enumActivityDetailsTableRow: Int, CaseIterable {
        case activityImage = 0
        case date
        case description
        case location
        case interestedUserList
    }
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: ActivityDetailsViewModel, viewModel1: InterestedActivityViewModel, viewController: ActivityDetailsVC) {
        self.viewController = viewController
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewModel1 = viewModel1
        super.init()
        setupTableView()
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
    
    //MARK: - Rgister Tableview cell xibs
    func registerTableCell(){
        tableView.registerNib(nibNames: [ActivityPictureCell.identifier, BorderedTextFieldCell.identifier, ActivityDescriptionCell.identifier, ActivityLikeUserCell.identifier, TVSectionCell.identifier, TextViewCell.identifier])
        tableView.reloadData()
    }
    
    //MARK: - UITableview Delegate Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch enumActivityDetailsTableRow(rawValue: section)! {
        case .activityImage:
            return CGFloat.leastNormalMagnitude
        case .date:
            return CGFloat.leastNormalMagnitude
        case .description:
            return CGFloat.leastNormalMagnitude
        case .location:
            return CGFloat.leastNormalMagnitude
        case .interestedUserList:
            if !viewModel.isCheckEmptyData() {
                return 50
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return enumActivityDetailsTableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch enumActivityDetailsTableRow(rawValue: section) {
        case .activityImage, .date, .description, .location:
            return UIView()
        case .interestedUserList:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: TVSectionCell.identifier) as! TVSectionCell
            return headerCell
        default:
            return viewController.view
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch enumActivityDetailsTableRow(rawValue: section) {
        case .activityImage, .date, .description, .location:
            return 1
        case .interestedUserList:
            if !viewModel.isCheckEmptyData() {
                return viewModel.getNumberOfInterestedUser()
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumActivityDetailsTableRow(rawValue: indexPath.section)! {
        case .activityImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityPictureCell.identifier) as! ActivityPictureCell
            cell.selectionStyle = .none
            
            cell.labelCategoryName.text = viewModel.getCategoryName()

            let strUrl = viewModel.getImageUrl()
            let url = URL(string: strUrl)
            cell.imageviewActivity.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageviewActivity.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_detailpage"), options: .refreshCached, context: nil)
            
            let profileImgUrl = "https://api.cliqued.app/\(loggedInUser?.userProfileMedia?.first?.url ?? "")"
            let urlProfile = URL(string: profileImgUrl)
            cell.imageviewUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageviewUser.sd_setImage(with: urlProfile, placeholderImage: UIImage(named: "placeholder_matchuser"), options: .refreshCached, context: nil)
            
            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: BorderedTextFieldCell.identifier) as! BorderedTextFieldCell
            cell.selectionStyle = .none
            cell.labelTextFieldTitle.text = Constants.label_date
            cell.textfiled.placeholder = Constants.placeholder_shortTitle
            
            let strDt = self.viewController.UTCToLocal(date: viewModel.getDate(), format: ACTIVITY_DATE_FORMAT)
            cell.textfiled.text = strDt
            
            cell.buttonDropDown.isHidden = true
            cell.labelMaxLimit.isHidden = true
            cell.textfiled.isUserInteractionEnabled = false
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityDescriptionCell.identifier) as! ActivityDescriptionCell
            cell.selectionStyle = .none
            cell.labelTextViewTitle.text = Constants.label_description
            cell.constraintTextviewHeight.constant = 105
            cell.textview.text = viewModel.getDescription()
            cell.labelMaxLimit.isHidden = true
            cell.textview.isEditable = false
            cell.textview.textColor = Constants.color_DarkGrey
            return cell
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.identifier) as! TextViewCell
            cell.selectionStyle = .none
            cell.buttonClick.isHidden = true
            cell.labelTitle.text = Constants.label_location
            cell.labelValue.text = viewModel.getLocation()
            return cell
        case .interestedUserList:
            if !viewModel.isCheckEmptyData() {
                let cell = tableView.dequeueReusableCell(withIdentifier: ActivityLikeUserCell.identifier) as! ActivityLikeUserCell
                cell.selectionStyle = .none
                
                let userInfoData = viewModel.getInterestedUserData(at: indexPath.row)
                cell.labelNameAndAge.text = "\(userInfoData?.name ?? ""), \(userInfoData?.age ?? 0)"
               
                let distance = userInfoData?.userDistanceInKm!.clean
                
                cell.labelKilometer.text = "\(distance ?? "0")km"
                
                if userInfoData?.userProfile != nil {
                    let img = userInfoData?.userProfile
                    let strUrl = UrlProfileImage + img!
                    let imageWidth = cell.imageviewUser.frame.size.width
                    let imageHeight = cell.imageviewUser.frame.size.height
                    let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
                    let url = URL(string: baseTimbThumb)
                    cell.imageviewUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imageviewUser.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_swipecard"), options: .refreshCached, context: nil)
                } else {
                    cell.imageviewUser.image = UIImage(named: "placeholder_swipecard")
                }
                
                //Hide button if user already take action on activity.
                if userInfoData?.isInterested == interestedActivityStatus.BothInterested || userInfoData?.isInterested == interestedActivityStatus.CreatorNotInterested {
                    cell.buttonLike.isHidden = true
                    cell.buttonDislike.isHidden = true
                } else {
                    cell.buttonLike.isHidden = false
                    cell.buttonDislike.isHidden = false
                }
                
                cell.buttonLike.tag = indexPath.row
                cell.buttonDislike.tag = indexPath.row
                
                cell.buttonLike.addTarget(self, action: #selector(btnLikeClick(_:)), for: .touchUpInside)
                cell.buttonDislike.addTarget(self, action: #selector(btnDislikeClick(_:)), for: .touchUpInside)
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    //MARK: Button Like Click
    @objc func btnLikeClick(_ sender: UIButton) {
        let userInfoData = viewModel.getInterestedUserData(at: sender.tag)
        viewModel1.setActivityId(value: "\(userInfoData?.activityId ?? 0)")
        viewModel1.setInterestedUserId(value: "\(userInfoData?.interestedUserId ?? 0)")
        viewModel1.setIsFollow(value: interestedActivityStatus.BothInterested)
        viewModel1.setActivityTitle(value: "\(viewController.objActivityDetails.title ?? "")")
        viewModel1.callLikeDislikeActivityAPI(isShowLoader: true)
    }
    
    //MARK: Button Dislike Click
    @objc func btnDislikeClick(_ sender: UIButton) {
        let userInfoData = viewModel.getInterestedUserData(at: sender.tag)
        viewModel1.setActivityId(value: "\(userInfoData?.activityId ?? 0)")
        viewModel1.setInterestedUserId(value: "\(userInfoData?.interestedUserId ?? 0)")
        viewModel1.setIsFollow(value: interestedActivityStatus.CreatorNotInterested)
        viewModel1.setActivityTitle(value: "\(viewController.objActivityDetails.title ?? "")")
        viewModel1.callLikeDislikeActivityAPI(isShowLoader: true)
    }
}
