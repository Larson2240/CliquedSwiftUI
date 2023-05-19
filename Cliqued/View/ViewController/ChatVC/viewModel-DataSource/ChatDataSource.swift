//
//  ChatDataSource.swift
//  Cliqued
//
//  Created by C100-132 on 28/01/23.
//

import UIKit
import SDWebImage

class ChatDataSource: NSObject {
    
    private let viewController: ChatVC
    private let collectionView: UICollectionView
    private let tableView : UITableView
    private let viewModel: ChatViewModel
    var context = CIContext(options: nil)
    
    //MARK:- Init
    init(collectionView: UICollectionView,tableView: UITableView, viewModel: ChatViewModel, viewController: ChatVC) {
        self.viewController = viewController
        self.collectionView = collectionView
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        setupCollectionView()
        setupTableView()
    }
    
    //MARK: - Class methods
    func setupCollectionView(){
        collectionView.backgroundColor = .clear
        registerCollectionCell()
    }
    
    func registerCollectionCell(){
        collectionView.registerNib(nibNames: [UserProfileCVC.identifier, NoDataFoundCVCell.identifier])
        collectionView.reloadData()
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
        tableView.registerNib(nibNames: [ChatUserTVCell.identifier])
        tableView.reloadData()
    }
    
    @objc func buttonUserProfileAction(_ sender: UIButton) {
        if viewModel.arrConversation.count > 0 {
            
            let obj = viewModel.arrConversation[sender.tag]
            
            if obj.isBlockByAdmin == "1" {
            } else if obj.isBlockedBySender == "1" {
            } else if obj.isBlockedByReceiver == "1" {
            }
             else {
                
                if UIApplication.getTopViewController() is ChatVC {
                    viewModel.callGetUserDetailsAPI(user_id: Int(obj.receiverId))
                }
            }
        }
    }
}

extension ChatDataSource : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !viewModel.getIsConversationDataLoad() {
            return 5
        } else {
            return viewModel.arrConversation.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatUserTVCell.identifier, for: indexPath) as! ChatUserTVCell
        
        if viewModel.getIsConversationDataLoad() {
            cell.hideAnimation()
            viewController.labelMessageSectionTitle.hideSkeleton()
            viewController.searchView.hideSkeleton()
        } else {
            viewModel.setIsConversationDataLoad(value: false)
            cell.layoutIfNeeded()
            return cell
        }
        
        if viewModel.arrConversation.count > 0 {
            
            let obj = viewModel.arrConversation[indexPath.row]
            
            cell.labelUserName.text = obj.receiverName
            
            cell.buttonUserProfile.tag = indexPath.row
            cell.buttonUserProfile.addTarget(self, action: #selector(buttonUserProfileAction(_:)), for: .touchUpInside)
            
            if let str = obj.receiverProfile  {
                let strUrl = UrlProfileImage + str
                
                let imageWidth = cell.imageUserProfile.frame.size.width
                let imageHeight = cell.imageUserProfile.frame.size.height
                
                let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
                
                let url = URL(string: baseTimbThumb)
                cell.imageUserProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imageUserProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_activity"), options: .highPriority, context: nil)
            } else {
                cell.imageUserProfile.image = UIImage(named: "placeholder_activity")
            }
            
            if obj.modifiedDate != nil {
                let str = obj.modifiedDate?.dateToString()
                cell.labelDate.text = viewController.getChatDateFromServerForLastSeen(strDate: str!)
            } else {
                cell.labelDate.text = ""
            }
            
            if obj.messageType != nil {
                if obj.messageType! == enumMessageType.text.rawValue {
                    cell.labelMessage.text = obj.messageText?.fromBase64()
                    cell.imageMsgTypeWidthConstant.constant = 0
                    cell.labelMessageLeadingConstant.constant = 0
                } else if obj.messageType! == enumMessageType.image.rawValue {
                    cell.imageMsgTypeWidthConstant.constant = 10
                    cell.labelMessageLeadingConstant.constant = 5
                    cell.imageMessageType.image = UIImage(named: "ic_image_chat")
                    cell.labelMessage.text = "Image"
                } else if obj.messageType! == enumMessageType.video.rawValue {
                    cell.labelMessage.text = "Video"
                    cell.imageMsgTypeWidthConstant.constant = 10
                    cell.labelMessageLeadingConstant.constant = 5
                    cell.imageMessageType.image = UIImage(named: "ic_image_chat")
                } else if obj.messageType! == enumMessageType.audio.rawValue {
                    cell.labelMessage.text = "Audio"
                    cell.imageMsgTypeWidthConstant.constant = 10
                    cell.labelMessageLeadingConstant.constant = 5
                    cell.imageMessageType.image = UIImage(named: "ic_voice_chat")
                } else {
                    cell.imageMsgTypeWidthConstant.constant = 10
                    cell.labelMessageLeadingConstant.constant = 5
                    cell.imageMessageType.image = UIImage(named: "ic_audiocallchat")
                    cell.labelMessage.text = "Call"
                }
            } else {
                cell.labelMessage.text = ""
            }
        }        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.arrConversation.count > 0 {
            
            let isIndexValid = viewModel.arrConversation.indices.contains(indexPath.row)
            
            if isIndexValid {
                let obj = viewModel.arrConversation[indexPath.row]
                let dict:NSMutableDictionary = NSMutableDictionary()
                
                if obj.senderId == (Constants.loggedInUser?.id)! {
                    dict.setValue("\(obj.receiverId)", forKey: "receiver_id")
                    dict.setValue("\(obj.senderId)", forKey: "user_id")
                } else {
                    dict.setValue("\(obj.senderId)", forKey: "receiver_id")
                    dict.setValue("\(obj.receiverId)", forKey: "user_id")
                }
                APP_DELEGATE.socketIOHandler?.updateUserChatStatus(data: dict)
            }
        }
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        if viewModel.arrSingleLikesList.count > 0 && viewModel.getIsPremium() == isPremium.Premium {
            let arrIds = viewModel.arrSingleLikesList.map({"\($0.userId ?? 0)"})
            let newString = arrIds.joined(separator: ",")
            
            let homeactivitiesVC = HomeActivitiesVC.loadFromNib()
            homeactivitiesVC.user_ids = newString
            homeactivitiesVC.hidesBottomBarWhenPushed = true
            viewController.navigationController?.pushViewController(homeactivitiesVC, animated: true)
        }
    }
}

extension ChatDataSource : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            if viewModel.getIsDataLoad() {
                if viewModel.arrSingleLikesList.count > 0 {
                    return 1
                } else {
                    return 0
                }
            } else {
                return 4
            }
        } else {
            if viewModel.isCheckEmptyData() {
                return 1
            } else {
                if viewModel.getIsDataLoad() {
                    return viewModel.arrMatchesList.count
                } else {
                    return 4
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            if viewModel.isCheckEmptyData() {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataFoundCVCell", for: indexPath) as! NoDataFoundCVCell
                cell.labelNoDataFound.text = Constants.label_noDataFound
                collectionView.isScrollEnabled = false
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileCVC.identifier, for: indexPath) as! UserProfileCVC
                
                if viewModel.getIsDataLoad() {
                    cell.hideAnimation()
                    viewController.labelNewMatchesTitle.hideSkeleton()
                } else {
                    viewModel.setIsDataLoad(value: false)
                    cell.layoutIfNeeded()
                    return cell
                }
                
                if viewModel.arrSingleLikesList.count > 0 {
                    let obj = viewModel.arrSingleLikesList[indexPath.item]
                    
                    cell.labelInterestedPeople.text = "\(viewModel.arrSingleLikesList.count)"
                    cell.labelInterestedPeople.isHidden = false
                    
                    if self.viewModel.getIsPremium() == isPremium.Premium {
                        let gestureRecognizer = UITapGestureRecognizer(
                            target: self, action:#selector(handleTap))
                        cell.labelInterestedPeople.addGestureRecognizer(gestureRecognizer)
                        cell.labelInterestedPeople.isUserInteractionEnabled = true
                    }
                    
                    if let img = obj.receiverProfile {
                        let strUrl = UrlProfileImage + img
                        cell.imageProfile.tag = indexPath.item
                        
                        let url = URL(string: strUrl)
                        cell.imageProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imageProfile.sd_setImage(with: url) { (image, error, cache, urls) in
                            if (error != nil) {
                                cell.imageProfile.image = UIImage(named: "placeholder_activity")
                            } else {
                                if let myimage = image {
                                    if self.viewModel.getIsPremium() == isPremium.Premium {
                                        cell.imageProfile.image = image
                                    } else {
                                        cell.imageProfile.image = self.blurEffect(userImage: myimage)
                                    }
                                }
                            }
                        }
                    } else {
                        cell.imageProfile.image = UIImage(named: "placeholder_activity")
                    }
                }
                
                return cell
            }
        } else {
            
            if viewModel.isCheckEmptyData() {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataFoundCVCell", for: indexPath) as! NoDataFoundCVCell
                cell.labelNoDataFound.text = Constants.label_noDataFound
                collectionView.isScrollEnabled = false
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileCVC.identifier, for: indexPath) as! UserProfileCVC
                
                if viewModel.getIsDataLoad() {
                    cell.hideAnimation()
                    viewController.labelNewMatchesTitle.hideSkeleton()
                } else {
                    viewModel.setIsDataLoad(value: false)
                    cell.layoutIfNeeded()
                    return cell
                }
                
                let obj = viewModel.arrMatchesList[indexPath.item]
                
                if obj.isMeetup == 1 {
                    cell.labelInterestedPeople.isHidden = true
                } else {
                    cell.labelInterestedPeople.text = "\(obj.interestedPeople ?? 0)"
                    cell.labelInterestedPeople.isHidden = false
                }
                
                if let img = obj.receiverProfile {
                    let strUrl = UrlProfileImage + img
                    cell.imageProfile.tag = indexPath.item
                    
                    let url = URL(string: strUrl)
                    cell.imageProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.imageProfile.sd_setImage(with: url) { (image, error, cache, urls) in
                        if (error != nil) {
                            cell.imageProfile.image = UIImage(named: "placeholder_activity")
                        } else {
                        }
                    }
                } else {
                    cell.imageProfile.image = UIImage(named: "placeholder_activity")
                }
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if !viewModel.isCheckEmptyData() {
            
            switch UIDevice().type {
            case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone6, .iPhone7, .iPhone8, .iPhone6S:
                viewController.matchViewHeightConstraint =  viewController.matchViewHeightConstraint.setMultiplier(multiplier: 0.23)
                break
                
            case .iPhone6Plus,.iPhone7Plus, .iPhone8Plus:
                viewController.matchViewHeightConstraint =  viewController.matchViewHeightConstraint.setMultiplier(multiplier: 0.24)
                break
                
            default:
                viewController.matchViewHeightConstraint =  viewController.matchViewHeightConstraint.setMultiplier(multiplier: 0.19)
                break
            }
            
            let cellWidth = collectionView.frame.size.width / 3 - 35
            let cellHeight = collectionView.frame.size.height
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let cellWidth = collectionView.frame.size.width
            let cellHeight = collectionView.frame.size.height
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if viewModel.getIsPremium() == isPremium.NotPremium {                
                let subscriptionplanvc = SubscriptionPlanVC.loadFromNib()
                subscriptionplanvc.isFromOtherScreen = true
                self.viewController.present(subscriptionplanvc, animated: true)
            } else {
                
            }
        } else {
            
            if self.viewModel.arrMatchesList.count > 0 {
                let obj = self.viewModel.arrMatchesList[indexPath.item]
                
                if obj.isBlockedByAdmin == "1" {
                    self.viewController.showAlertPopup(message: Constants_Message.title_alert_for_block_by_admin_chat)
                } else if obj.isBlockedByUser == "1" {
                    self.viewController.showAlertPopup(message: Constants_Message.title_alert_for_block_by_user_chat)
                } else if viewModel.getIsPremium() == isPremium.NotPremium {
                    if obj.isMeetup == isMeetup.Matched {
                        viewController.selectedUser = indexPath.item
                        viewController.selectedSection = indexPath.section
                        let dict:NSMutableDictionary = NSMutableDictionary()
                        
                        if obj.userId == Constants.loggedInUser?.id {
                            dict.setValue("\(obj.counterUserId ?? 0)", forKey: "receiver_id")
                            dict.setValue("\(obj.userId ?? 0)", forKey: "user_id")
                        } else {
                            dict.setValue("\(obj.userId ?? 0)", forKey: "receiver_id")
                            dict.setValue("\(obj.counterUserId ?? 0)", forKey: "user_id")
                        }
                        APP_DELEGATE.socketIOHandler?.updateUserChatStatus(data: dict)
                    } else {
                        let subscriptionplanvc = SubscriptionPlanVC.loadFromNib()
                        subscriptionplanvc.isFromOtherScreen = true
                        self.viewController.present(subscriptionplanvc, animated: true)
                    }
                } else {
                    viewController.selectedUser = indexPath.item
                    viewController.selectedSection = indexPath.section
                    let dict:NSMutableDictionary = NSMutableDictionary()
                    dict.setValue("\(obj.counterUserId ?? 0)", forKey: "receiver_id")
                    dict.setValue("\(obj.userId ?? 0)", forKey: "user_id")
                    APP_DELEGATE.socketIOHandler?.updateUserChatStatus(data: dict)
                }
            }
        }
     
    }
    
    //MARK: Add blur effect on image
    func blurEffect(userImage: UIImage) -> UIImage? {
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: userImage)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(15, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
}

