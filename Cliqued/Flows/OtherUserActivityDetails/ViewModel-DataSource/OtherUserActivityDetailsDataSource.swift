//
//  OtherUserDetailsDataSource.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit
import SDWebImage
import MapKit
import CoreLocation

class OtherUserActivityDetailsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewController: OtherUserActivityDetailsVC
    private let tableView: UITableView
    private let viewModel: OtherUserActivityDetailsViewModel
    
    enum enumOtherUserActivityTableRow: Int, CaseIterable {
        case activityImage = 0
        case date
        case description
        case location
    }
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: OtherUserActivityDetailsViewModel, viewController: OtherUserActivityDetailsVC) {
        self.viewController = viewController
        self.tableView = tableView
        self.viewModel = viewModel
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
    
    func registerTableCell(){
        tableView.registerNib(nibNames: [ActivityPictureCell.identifier, BorderedTextFieldCell.identifier, ActivityDescriptionCell.identifier, ActivityLocationCell.identifier])
        tableView.reloadData()
    }
    
    @objc func buttonUserProfileAction(_ sender: UIButton) {
        viewModel.callGetUserDetailsAPI(user_id: viewModel.activity_owner_id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enumOtherUserActivityTableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumOtherUserActivityTableRow(rawValue: indexPath.row)! {
        case .activityImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityPictureCell.identifier) as! ActivityPictureCell
            cell.selectionStyle = .none
            
            cell.labelCategoryName.text = viewModel.getCategoryName()
            
            cell.buttonUserProfile.tag = indexPath.row
            cell.buttonUserProfile.addTarget(self, action: #selector(buttonUserProfileAction(_:)), for: .touchUpInside)
            
            let strUrl = viewModel.getImageUrl()
            let imageWidth = cell.imageviewActivity.frame.size.width
            let imageHeight = cell.imageviewActivity.frame.size.height
            let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
            let url = URL(string: baseTimbThumb)
            
            cell.imageviewActivity.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageviewActivity.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_detailpage"), options: .refreshCached, context: nil)
            
            let profileImgUrl = UrlProfileImage + viewModel.getUserProfileUrl()
            let imageWidth1 = cell.imageviewActivity.frame.size.width
            let imageHeight1 = cell.imageviewActivity.frame.size.height
            let baseTimbThumb1 = "\(URLBaseThumb)w=\(imageWidth1 * 3)&h=\(imageHeight1 * 3)&zc=1&src=\(profileImgUrl)"
            let urlProfile = URL(string: baseTimbThumb1)
            cell.imageviewUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageviewUser.sd_setImage(with: urlProfile, placeholderImage: UIImage(named: "placeholder_matchuser"), options: .refreshCached, context: nil)
            
            if let imgUrl = viewController.objActivityDetails?.userProfile {
                let strUrl = UrlProfileImage + imgUrl
                let imageWidth1 = cell.imageviewUser.frame.size.width
                let imageHeight1 = cell.imageviewUser.frame.size.height
                let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth1 * 3)&h=\(imageHeight1 * 3)&zc=1&src=\(strUrl)"
                let url = URL(string: baseTimbThumb)
                
                cell.imageviewUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imageviewUser.sd_setImage(with: url, placeholderImage: UIImage(), options: .refreshCached, context: nil)
            }
            
            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: BorderedTextFieldCell.identifier) as! BorderedTextFieldCell
            cell.selectionStyle = .none
            cell.labelTextFieldTitle.text = Constants.label_date
            cell.textfiled.placeholder = Constants.placeholder_shortTitle
            
            let strDt = self.viewController.UTCToLocal(date: viewModel.getDate(), format: ACTIVITY_DATE_FORMAT)
            cell.textfiled.text = strDt
            
            //            if let str = viewModel.objActivityDetails?.activityDate {
            //                let strDt = self.viewController.UTCToLocal(date: str, format: ACTIVITY_DATE_FORMAT)
            //                cell.textfiled.text = strDt
            //            }
            
            cell.buttonDropDown.isHidden = true
            cell.labelMaxLimit.isHidden = true
            cell.textfiled.isUserInteractionEnabled = false
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityDescriptionCell.identifier) as! ActivityDescriptionCell
            cell.selectionStyle = .none
            cell.labelTextViewTitle.text = Constants.label_description
            cell.constraintTextviewHeight.constant = 105
            //            cell.textview.text = viewModel.objActivityDetails?.descriptionValue
            cell.textview.text = viewModel.getDescription()
            cell.labelMaxLimit.isHidden = true
            cell.textview.isEditable = false
            cell.textview.textColor = Constants.color_DarkGrey
            return cell
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityLocationCell.identifier) as! ActivityLocationCell
            cell.selectionStyle = .none
            cell.labelLocationTitle.text = Constants.label_location
            
            cell.mapview.mapType = .standard
            cell.mapview.isZoomEnabled = false
            cell.mapview.isScrollEnabled = false
            
            if let arrAddress = viewController.objActivityDetails?.activityDetails,arrAddress.count > 0 {
                
                let obj = arrAddress[0]
                
                let lat = Double(obj.latitude!)
                let long = Double(obj.longitude!)
                
                let locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: locValue, span: span)
                cell.mapview.setRegion(region, animated: true)
                
                let newPin = MKPointAnnotation()
                newPin.coordinate = locValue
                cell.mapview.addAnnotation(newPin)
                
                if let coor = cell.mapview.userLocation.location?.coordinate {
                    cell.mapview.setCenter(coor, animated: true)
                }
                
                if (obj.city != "") && (obj.state != "") {
                    let address = "\(obj.city ?? "-"), \(obj.state ?? "")"
                    cell.buttonCurrentLocation.setTitle(address, for: .normal)
                } else {
                    let address = "-"
                    cell.buttonCurrentLocation.setTitle(address, for: .normal)
                }
                cell.buttonCurrentLocation.setImage(nil, for: .normal)
            }
            return cell
        }
    }
}
