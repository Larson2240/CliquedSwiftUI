//
//  InterestedActivityVC.swift
//  Cliqued
//
//  Created by C211 on 21/02/23.
//

import UIKit
import Koloda
import SDWebImage
import GoogleMobileAds
import SocketIO

class InterestedActivityVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var labelSubCategoryTitle: UILabel!{
        didSet {
            labelSubCategoryTitle.font = CustomFont.THEME_FONT_Bold(16)
            labelSubCategoryTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var viewActivityCard: KolodaView!{
        didSet {
            viewActivityCard.layer.cornerRadius = 50.0
        }
    }
    @IBOutlet weak var cardView: InterestUserActivityView!
    @IBOutlet weak var imageviewLikeDislikeIcon: UIImageView!
    @IBOutlet weak var labelNoActivityAvailable: UILabel!{
        didSet {
            labelNoActivityAvailable.font = CustomFont.THEME_FONT_Medium(14)
            labelNoActivityAvailable.textColor = Constants.color_MediumGrey
        }
    }
    
    //MARK: Variable
    lazy var viewModel = InterestedActivityViewModel()
    lazy var viewModelDiscoveryAcvitiy = DiscoverActivityViewModel()
    var activity_id = ""
    var categoryName = ""
    var subCategoryName = ""
    private var selectedIndextValue = -1
    var isLikeLimitFinish: Bool = false
    var ifFromDiscoveryAcitivy: Bool = false
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APP_DELEGATE.socketIOHandler?.delegate = self
    }
    
}
//MARK: Extension UDF
extension InterestedActivityVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupKolodaCard()
        viewModel.setActivityId(value: activity_id)
        viewModel.callInterestedActivityListAPI()
        self.labelSubCategoryTitle.text = self.subCategoryName
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = self.categoryName
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Setup Koloda Card
    func setupKolodaCard() {
        viewActivityCard.backgroundCardsTopMargin = 0.0
        viewActivityCard.dataSource = self
        viewActivityCard.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { message in
            self.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { isSuccess in
            if isSuccess {
                self.viewActivityCard.countOfVisibleCards = self.viewModel.getNumberOfInterestedUser()
                self.viewActivityCard.reloadData()
            }
        }
        
        viewModel.isLikdDislikeSuccess.bind { isSuccess in
            if isSuccess {
                if self.viewModel.arrayOfFollowersList.count > 0 {
                    let followersData = self.viewModel.arrayOfFollowersList[0]
                    if followersData.isMeetup == isMeetup.Matched  {
                      
                    } else {
                        if self.viewModel.getLikesLimit() != 0 {
                            if !self.isLikeLimitFinish {
                                if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
                                    self.showGoogleAds()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        viewModel.isViewLimitFinish.bind { isSuccess in
            if isSuccess {
                if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
                    self.labelNoActivityAvailable.text = Constants.label_noDataFound
                    self.showSubscriptionPlanScreen()
                }
            }
        }
        
        viewModel.isLikeLimitFinish.bind { isSuccess in
            if isSuccess {
                if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
                    self.isLikeLimitFinish = true
                    self.viewActivityCard.revertAction()
                    self.showSubscriptionPlanScreen()
                }
            }
        }
        
        viewModelDiscoveryAcvitiy.isUserDataGet.bind { isSuccess in
            if isSuccess {
                if self.viewModel.arrayOfInterestedUserList.count > 0 {
                    let activityuserdetailsvc = ActivityUserDetailsVC.loadFromNib()
                    activityuserdetailsvc.objUserDetails = self.viewModelDiscoveryAcvitiy.arrayOfMainUserList[0]
                    activityuserdetailsvc.hidesBottomBarWhenPushed = true
                    activityuserdetailsvc.is_fromChatActivity = true
                    self.navigationController?.pushViewController(activityuserdetailsvc, animated: true)
                }
            }
        }
        
        //Loader hide & show
        viewModelDiscoveryAcvitiy.isLoaderShow.bind { isLoader in
            if isLoader {
                self.showLoader()
            } else {
                self.dismissLoader()
            }
        }
        
        //Loader hide & show
        viewModel.isLoaderShow.bind { isLoader in
            if isLoader {
                self.showLoader()
            } else {
                self.dismissLoader()
            }
        }
    }
    //MARK: Show subscription screen for basic user
    func showSubscriptionPlanScreen() {
        let subscriptionplanvc = SubscriptionPlanVC.loadFromNib()
        subscriptionplanvc.isFromOtherScreen = true
        self.present(subscriptionplanvc, animated: true)
    }
}
//MARK: Extension for Koloda Delegate Method
extension InterestedActivityVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
        if viewModel.getLikesLimit() != 0 {
            viewModel.arrayOfDuplicateInterestedUserList.removeAll()
        }
        if viewModel.getAllInterestedUserData().count == 0 {
            viewActivityCard.isHidden = true
            labelNoActivityAvailable.isHidden = false
            labelNoActivityAvailable.text = Constants.label_noDataFound
            //Show subscription screen for basic user
            if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
                showSubscriptionPlanScreen()
            }
        }
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
    }
}

//MARK: Extension for Koloda DataSource Method
extension InterestedActivityVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        if !viewModel.isCheckEmptyData() {
            return viewModel.getNumberOfInterestedUser()
        } else {
            viewActivityCard.isHidden = true
            labelNoActivityAvailable.isHidden = false
            labelNoActivityAvailable.text = Constants.label_noDataFound
            return 0
        }
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        if !viewModel.isCheckEmptyData() {
            let card = InterestUserActivityView()
            
            let userInfoData = viewModel.getInterestedUserData(at: index)
            
            //Hide button if user already take action on activity.
            if userInfoData?.isInterested == interestedActivityStatus.BothInterested || userInfoData?.isInterested == interestedActivityStatus.CreatorNotInterested {
                card.buttonLike.isHidden = true
                card.buttonDislike.isHidden = true
                card.viewSendMessageButton.isHidden = false
            } else {
                card.buttonLike.isHidden = false
                card.buttonDislike.isHidden = false
                card.viewSendMessageButton.isHidden = true
            }
            
            card.labelUserNameAndAge.text = "\(userInfoData?.name ?? ""), \(userInfoData?.age ?? 0)"
            
            if userInfoData?.userDistanceInKm != nil {
                let distance = userInfoData?.userDistanceInKm!.clean
                card.labelLocationDistance.text = "\(distance ?? "0") km away"
            } else {
                let distance = String(format: "%.2f", userInfoData?.userDistanceInKm ?? 0.0)
                card.labelLocationDistance.text = "\(distance ) km away"
            }
            
            if userInfoData?.userProfile != nil {
                let img = userInfoData?.userProfile
                let strUrl = UrlProfileImage + img!
                let imageWidth = card.imageview.frame.size.width
                let imageHeight = card.imageview.frame.size.height
                let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
                let url = URL(string: baseTimbThumb)
                card.imageview.sd_imageIndicator = SDWebImageActivityIndicator.gray
                card.imageview.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_swipecard"), options: .refreshCached, context: nil)
            } else {
                card.imageview.image = UIImage(named: "placeholder_swipecard")
            }
            card.buttonInfo.tag = index
            card.buttonLike.tag = index
            card.buttonDislike.tag = index
            card.buttonSendMessage.tag = index
            
            card.buttonInfo.addTarget(self, action: #selector(buttonInfoTap(_:)), for: .touchUpInside)
            card.buttonLike.addTarget(self, action: #selector(buttonLikeActivityTap(_:)), for: .touchUpInside)
            card.buttonDislike.addTarget(self, action: #selector(buttonDislikeActivityTap(_:)), for: .touchUpInside)
            card.buttonSendMessage.addTarget(self, action: #selector(buttonSendMessageTap(_:)), for: .touchUpInside)
            return card
        } else {
            viewActivityCard.isHidden = true
            labelNoActivityAvailable.isHidden = false
            return UIView()
        }
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.up, .down, .topLeft, .topRight, .bottomLeft, .bottomRight]
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        imageviewLikeDislikeIcon.isHidden = true
        if direction == .up || direction == .topLeft || direction == .topRight {
            if viewModel.getAllInterestedUserData().count > 0 {
                
                let userInfoData = viewModel.getInterestedUserData(at: index)
                
                if userInfoData?.isInterested == interestedActivityStatus.BothInterested || userInfoData?.isInterested == interestedActivityStatus.CreatorNotInterested {
                    viewModel.setIsFollow(value: "-1")
                } else {
                    viewModel.setActivityId(value: "\(activity_id)")
                    viewModel.setInterestedUserId(value: "\(userInfoData?.interestedUserId ?? 0)")
                    viewModel.setIsFollow(value: interestedActivityStatus.BothInterested)
                    viewModel.setActivityTitle(value: "\(categoryName )")
                    viewModel.callLikeDislikeActivityAPI(isShowLoader: false)
                }
            }
        } else if direction == .down || direction == .bottomLeft || direction == .bottomRight {
            if viewModel.getAllInterestedUserData().count > 0 {
                
                let userInfoData = viewModel.getInterestedUserData(at: index)
                
                if userInfoData?.isInterested == interestedActivityStatus.BothInterested || userInfoData?.isInterested == interestedActivityStatus.CreatorNotInterested {
                    viewModel.setIsFollow(value: "-1")
                } else {
                    viewModel.setActivityId(value: "\(activity_id)")
                    viewModel.setInterestedUserId(value: "\(userInfoData?.interestedUserId ?? 0)")
                    viewModel.setIsFollow(value: interestedActivityStatus.CreatorNotInterested)
                    viewModel.setActivityTitle(value: "\(categoryName )")
                    viewModel.callLikeDislikeActivityAPI(isShowLoader: false)
                }
                if viewModel.getLikesLimit() != 0 {
                    if !isLikeLimitFinish {
                        if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
                            showGoogleAds()
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.imageviewLikeDislikeIcon.isHidden = true
            }
        }
    }
    
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
        if direction == .up || direction == .topLeft || direction == .topRight {
            imageviewLikeDislikeIcon.isHidden = false
            imageviewLikeDislikeIcon.image = UIImage(named: "ic_like_swipe")
        } else if direction == .down || direction == .bottomLeft || direction == .bottomRight {
            imageviewLikeDislikeIcon.isHidden = false
            imageviewLikeDislikeIcon.image = UIImage(named: "ic_dislike_swipe")
        } else {
            imageviewLikeDislikeIcon.isHidden = true
        }
    }
    
    func kolodaDidResetCard(_ koloda: KolodaView) {
        imageviewLikeDislikeIcon.isHidden = true
    }
    
    func showGoogleAds() {
        let nativeadvc = NativeAdViewVC.loadFromNib()
        nativeadvc.isFromInterestedActivityScreen = true
        nativeadvc.subTitle = self.subCategoryName
        nativeadvc.screenTitle = self.categoryName
        nativeadvc.modalPresentationStyle = .fullScreen
        self.present(nativeadvc, animated: false)
    }
    
    //MARK: Button Info tap
    @objc func buttonInfoTap(_ sender: UIButton) {
        let obj = self.viewModel.getInterestedUserData(at: sender.tag)
        viewModelDiscoveryAcvitiy.callGetUserDetailsAPI(user_id: obj?.interestedUserId ?? 0)
    }
    
    //MARK: Button Like Activity Tap
    @objc func buttonLikeActivityTap(_ sender: UIButton) {
        imageviewLikeDislikeIcon.isHidden = false
        imageviewLikeDislikeIcon.image = UIImage(named: "ic_like_swipe")
        viewActivityCard.swipe(.up)
    }
    
    //MARK: Button Dislike Activity Tap
    @objc func buttonDislikeActivityTap(_ sender: UIButton) {
        imageviewLikeDislikeIcon.isHidden = false
        imageviewLikeDislikeIcon.image = UIImage(named: "ic_dislike_swipe")
        viewActivityCard.swipe(.down)
    }
    
    //MARK: Button Send Message Tap
    @objc func buttonSendMessageTap(_ sender: UIButton) {
        
        if self.viewModel.arrayOfDuplicateInterestedUserList.count > 0 {
            
            let objFollower = self.viewModel.arrayOfDuplicateInterestedUserList[sender.tag]
            selectedIndextValue = sender.tag
            
            if objFollower.is_blocked_by_admin == "1" {
                self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_admin_chat)
            } else if objFollower.receiver_is_blocked_by_user == "1" {
                self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_user_chat)
            } else {
                let dict:NSMutableDictionary = NSMutableDictionary()
                dict.setValue("\(objFollower.interestedUserId ?? 0)", forKey: "receiver_id")
                dict.setValue("\(Constants.loggedInUser?.id ?? 0)", forKey: "user_id")
                APP_DELEGATE.socketIOHandler?.updateUserChatStatus(data: dict)
            }
        }
    }
}
//MARK: Extension UDF
extension InterestedActivityVC: GADFullScreenContentDelegate {
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}
extension InterestedActivityVC : SocketIOHandlerDelegate {
    
    func connectionStatus(status: SocketIOStatus) {
        
    }
    
    func reloadConversation() {
        
    }
    
    func reloadUserChatStatus(sender_id:Int, receiver_id:Int,is_delete:String) {
        let strPredicate = NSString(format: "(senderId = %d AND receiverId = %d) OR (senderId = %d AND receiverId = %d)",sender_id,receiver_id,receiver_id,sender_id)
        
        let arr = CoreDataAdaptor.sharedDataAdaptor.fetchListWhere(predicate: NSPredicate (format: strPredicate as String))
        
        if arr.count > 0 {
            
            let obj = arr[0]
            var strLastSeen = ""
            
            if obj.lastSeen != nil {
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let ldate = dateFormate.string(from: obj.lastSeen!)
                strLastSeen = ldate
            } else {
                strLastSeen = "0000-00-00 00:00:00"
            }
            
            if is_delete == "1" {
                self.showAlertPopup(message: Constants_Message.title_alert_for_deleted_user)
            } else if obj.isBlockByAdmin == "1" {
                self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_admin_chat)
            } else if obj.isBlockedBySender == "1" {
                self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_user_chat)
            } else {
                let vc = MessageVC.loadFromNib()
                vc.hidesBottomBarWhenPushed = true
                vc.sender_id = Constants.loggedInUser?.id ?? 0
                
                if "\(obj.senderId)" == "\(Constants.loggedInUser?.id ?? 0)" {
                    vc.receiver_id = Int(obj.receiverId)
                } else {
                    vc.receiver_id = Int(obj.senderId)
                }
                                
                vc.receiver_name = "\(obj.receiverName ?? "Cliqued User")"
                vc.receiver_profile = "\(obj.receiverProfile ?? "")"
                vc.receiver_last_seen = strLastSeen
                vc.receiver_is_online = "\(obj.isOnline ?? "")"
                vc.conversation_id = Int(obj.conversationId)
                vc.receiver_is_last_seen_enable = "\(obj.isLastSeenEnabled ?? "")"
                vc.recevier_chat_status = "\(obj.chatStatus ?? "")"
                vc.is_fromMatchScreen = false
                vc.is_blocked = obj.isBlockedByReceiver == "1" ? true : false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            
            if self.viewModel.arrayOfDuplicateInterestedUserList.count > 0 {
                
                let objFollower = self.viewModel.arrayOfDuplicateInterestedUserList[selectedIndextValue]
                
                if objFollower.is_blocked_by_admin == "1" {
                    self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_admin_chat)
                } else if objFollower.receiver_is_blocked_by_user == "1" {
                    self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_user_chat)
                } else {
                    let vc = MessageVC.loadFromNib()
                    vc.hidesBottomBarWhenPushed = true
                    vc.sender_id = Constants.loggedInUser?.id ?? 0
                    
                    
                    vc.receiver_id = (objFollower.interestedUserId)!
                    vc.receiver_profile = "\(objFollower.userProfile ?? "")"
                    vc.receiver_name = "\(objFollower.name ?? "")"
                    vc.receiver_last_seen = "\(objFollower.receiver_last_seen ?? "")"
                    vc.receiver_is_online = "\(objFollower.receiver_is_online ?? "")"
                    vc.receiver_is_last_seen_enable = "\(objFollower.is_last_seen_enabled ?? "")"
                    vc.recevier_chat_status = "\(objFollower.chat_status ?? "")"
                    
                    
                    vc.conversation_id = objFollower.conversation_id ?? 0
                    vc.is_fromMatchScreen = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
