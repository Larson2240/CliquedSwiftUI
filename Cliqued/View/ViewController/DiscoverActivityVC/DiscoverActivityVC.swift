//
//  DiscoverActivityVC.swift
//  Cliqued
//
//  Created by C100-132 on 03/02/23.
//

import UIKit
import Koloda
import SDWebImage
import GoogleMobileAds

class DiscoverActivityVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var viewActivityCard: KolodaView!{
        didSet {
            viewActivityCard.layer.cornerRadius = 50.0
        }
    }
    
    @IBOutlet weak var cardView: DiscoveryActivityView!
    @IBOutlet weak var imageviewLikeDislikeIcon: UIImageView!
    @IBOutlet weak var labelNoActivityAvailable: UILabel!{
        didSet {
            labelNoActivityAvailable.font = CustomFont.THEME_FONT_Medium(14)
            labelNoActivityAvailable.textColor = Constants.color_MediumGrey
        }
    }
    
    //MARK: Variable
    var dataSource : DiscoverActivityDataSource?
    lazy var viewModel = DiscoverActivityViewModel()
    var isBackFromDetailScreen: Bool = false
    var isLikeLimitFinish: Bool = false
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
}

//MARK: Extension UDF
extension DiscoverActivityVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupKolodaCard()
        self.viewModel.setUserId(value: "\(Constants.loggedInUser?.id ?? 0)")
        
        // Manage api request for logged in user preferences and categories
        if let arrCategory = Constants.loggedInUser?.userInterestedCategory {
            var arrActivityId = arrCategory.map({$0.activityId!})
            arrActivityId = arrActivityId.removeDuplicates()
            
            let strActivityId = arrActivityId.map{String($0)}.joined(separator: ",")
            self.viewModel.setActivityCategoryId(value: strActivityId)
            
            var arrSubActivityId = arrCategory.map({$0.subActivityId!})
            arrSubActivityId = arrSubActivityId.removeDuplicates()
            
            let strSubActivityId = arrSubActivityId.map{String($0)}.joined(separator: ",")
            self.viewModel.setActivitySubCategoryId(value: strSubActivityId)
        }
       
        var arrayOfUserPreference = [UserPreferences]()
        var arrayOfLookingForIds = [Int]()
        arrayOfUserPreference = (Constants.loggedInUser?.userPreferences)!
        if arrayOfUserPreference.count > 0 {
            for i in arrayOfUserPreference {
                if i.typesOfPreference == PreferenceTypeIds.looking_for {
                    arrayOfLookingForIds.append(i.id ?? 0)
                }
            }
        }
        let commaSepLookingForIds = arrayOfLookingForIds.map{String($0)}.joined(separator: ",")
        
        var arrayDistancePreference = [Int]()
        if arrayOfUserPreference.count > 0 {
            for i in arrayOfUserPreference {
                if i.typesOfPreference == PreferenceTypeIds.distance {
                    arrayDistancePreference.append(i.preferenceOptionId ?? 0)
                }
            }
        }
        let commaSepDistance = arrayDistancePreference.map{String($0)}.joined(separator: ",")
        
        var arrayKidsPreference = [Int]()
        if arrayOfUserPreference.count > 0 {
            for i in arrayOfUserPreference {
                if i.typesOfPreference == PreferenceTypeIds.kids {
                    arrayKidsPreference.append(i.preferenceOptionId ?? 0)
                }
            }
        }
        let commaSepKids = arrayKidsPreference.map{String($0)}.joined(separator: ",")
        
        var arraySmokePreference = [Int]()
        if arrayOfUserPreference.count > 0 {
            for i in arrayOfUserPreference {
                if i.typesOfPreference == PreferenceTypeIds.smoking {
                    arraySmokePreference.append(i.preferenceOptionId ?? 0)
                }
            }
        }
        let commaSepSmoke = arraySmokePreference.map{String($0)}.joined(separator: ",")
        
        var arrayAgeStartPreference = [Int]()
        if arrayOfUserPreference.count > 0 {
            for i in arrayOfUserPreference {
                if i.subTypesOfPreference == PreferenceTypeIds.age_start {
                    arrayAgeStartPreference.append(i.preferenceOptionId ?? 0)
                }
            }
        }
        let commaSepAgeStart = arrayAgeStartPreference.map{String($0)}.joined(separator: ",")
        
        var arrayAgeEndPreference = [Int]()
        if arrayOfUserPreference.count > 0 {
            for i in arrayOfUserPreference {
                if i.subTypesOfPreference == PreferenceTypeIds.age_end {
                    arrayAgeEndPreference.append(i.preferenceOptionId ?? 0)
                }
            }
        }
        let commaSepAgeEnd = arrayAgeEndPreference.map{String($0)}.joined(separator: ",")
                
        self.viewModel.setLookingForIds(value: commaSepLookingForIds)
        self.viewModel.setKidsOptionId(value: commaSepKids)
        self.viewModel.setSmokingOptionId(value: commaSepSmoke)
        self.viewModel.setAgeStartPrefId(value: commaSepAgeStart)
        self.viewModel.setAgeEndPrefId(value: commaSepAgeEnd)
        self.viewModel.setDistancePrefId(value: commaSepDistance)        
        self.viewModel.callActivityListAPI()
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants_Message.title_discover_activity
               
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonSkip.isHidden = true
        viewNavigationBar.buttonRight.isHidden = false
        viewNavigationBar.buttonRight.addTarget(self, action: #selector(buttonGuideTap), for: .touchUpInside)
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Back Button Action
    @objc func buttonGuideTap() {
        let guidemanagervc = GuideManagerVC.loadFromNib()
        guidemanagervc.isFromActivitySwipeScreen = true
        self.navigationController?.pushViewController(guidemanagervc, animated: false)
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
                self.viewActivityCard.countOfVisibleCards = self.viewModel.getNumberOfDuplicateOtherActivity()
                self.viewActivityCard.reloadData()
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
        
        viewModel.isUserDataGet.bind { isSuccess in
            if isSuccess {
                if self.viewModel.arrayOfMainUserList.count > 0 {
                    let activityuserdetailsvc = ActivityUserDetailsVC.loadFromNib()
                    activityuserdetailsvc.objUserDetails = self.viewModel.arrayOfMainUserList[0]
                    activityuserdetailsvc.hidesBottomBarWhenPushed = true
                    activityuserdetailsvc.is_fromChatActivity = true
                    self.navigationController?.pushViewController(activityuserdetailsvc, animated: true)
                }
            }
        }
        
        viewModel.isMarkStatusDataGet.bind { isSuccess in
            if isSuccess {
                
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
extension DiscoverActivityVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
        if viewModel.getLikesLimit() != 0 {
            viewModel.arrOtherActivitiesDuplicate.removeAll()
        }
        viewModel.arrOtherActivitiesDuplicate.removeAll()
        if viewModel.getAllDuplicationOhterActivityData().count == 0 {
            viewActivityCard.isHidden = true
            labelNoActivityAvailable.isHidden = false
            labelNoActivityAvailable.text = Constants.label_noDataFound
        }
    }
    
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
    }
    
    func kolodaPanBegan(_ koloda: KolodaView, card: DraggableCardView) {        
    }
    
    func kolodaPanFinished(_ koloda: KolodaView, card: DraggableCardView) {
        
    }
}

//MARK: Extension for Koloda DataSource Method
extension DiscoverActivityVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        if !viewModel.isCheckEmptyData() {
            return viewModel.getNumberOfDuplicateOtherActivity()
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
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.up, .down, .topLeft, .topRight, .bottomLeft, .bottomRight]
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        if !viewModel.isCheckEmptyData() {
            let card = DiscoveryActivityView()
            
            let activityData = viewModel.getDuplicateOtherActivityData(at: index)
            card.labelCategoryName.text = activityData.activityCategoryTitle ?? ""
            card.labelActivityName.text = activityData.title ?? ""
            
            if let arr = activityData.activityMedia, arr.count > 0 {
                let isImageData = arr.filter({$0.mediaType == "0"})
                let img = isImageData[0].url
                let strUrl = UrlUserActivity + img!
                
                let imageWidth = card.imageview.frame.size.width
                let imageHeight = card.imageview.frame.size.height
                
                let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
                
                print("user profile = \(baseTimbThumb)")
                
                let url = URL(string: baseTimbThumb)
                
                card.imageview.sd_imageIndicator = SDWebImageActivityIndicator.gray
                card.imageview.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_swipecard"), options: .refreshCached, context: nil)
            }
            
            if let image = activityData.userProfile {
                let strUrl = UrlProfileImage + image
                
                let imageWidth1 = card.imageviewActivityOwner.frame.size.width
                let imageHeight1 = card.imageviewActivityOwner.frame.size.height
                
                let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth1 * 3)&h=\(imageHeight1 * 3)&zc=1&src=\(strUrl)"
                let url = URL(string: baseTimbThumb)
                card.imageviewActivityOwner.sd_imageIndicator = SDWebImageActivityIndicator.gray
                card.imageviewActivityOwner.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_matchuser"), options: .refreshCached, context: nil)
            } else {
                card.imageviewActivityOwner.image = UIImage(named: "placeholder_matchuser")
            }
            
            
            card.buttonInfo.tag = index
            card.buttonLike.tag = index
            card.buttonDislike.tag = index
            card.buttonActivityOwnerInfo.tag = index
            
            card.buttonInfo.addTarget(self, action: #selector(buttonActivityUserDetailsTap(_:)), for: .touchUpInside)
            card.buttonActivityOwnerInfo.addTarget(self, action: #selector(buttonOwnerUserDetailsTap(_:)), for: .touchUpInside)
            card.buttonLike.addTarget(self, action: #selector(buttonLikeActivityTap(_:)), for: .touchUpInside)
            card.buttonDislike.addTarget(self, action: #selector(buttonDislikeActivityTap(_:)), for: .touchUpInside)
            return card
        } else {
            viewActivityCard.isHidden = true
            labelNoActivityAvailable.isHidden = false
            return UIView()
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
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection){
        
        if !isBackFromDetailScreen {
            if direction == .up || direction == .topLeft || direction == .topRight {
                if viewModel.getAllDuplicationOhterActivityData().count > 0 {
                    let activityData = viewModel.getDuplicateOtherActivityData(at: index)
                    viewModel.setUserId(value: "\(Constants.loggedInUser?.id ?? 0)")
                    viewModel.setActivityId(value: "\(activityData.id ?? 0)")
                    viewModel.setActivityInterestStatus(value: "1")
                    viewModel.setOwnerId(value: "\(activityData.userId ?? 0)")
                    viewModel.setActivityName(value: "\(activityData.title ?? "")")
                    viewModel.callMarkActivityStatusAPI()
                    
                    if viewModel.getLikesLimit() != 0 {
                        if !isLikeLimitFinish {
                            if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
                                showGoogleAds()
                            }
                        }
                    }
                }
            } else if direction == .down || direction == .bottomLeft || direction == .bottomRight {
                if viewModel.getAllDuplicationOhterActivityData().count > 0 {
                    let activityData = viewModel.getDuplicateOtherActivityData(at: index)
                    viewModel.setUserId(value: "\(Constants.loggedInUser?.id ?? 0)")
                    viewModel.setActivityId(value: "\(activityData.id ?? 0)")
                    viewModel.setActivityInterestStatus(value: "0")
                    viewModel.setOwnerId(value: "\(activityData.userId ?? 0)")
                    viewModel.setActivityName(value: "\(activityData.title ?? "")")
                    viewModel.callMarkActivityStatusAPI()
                    
                    if viewModel.getLikesLimit() != 0 {
                        if !isLikeLimitFinish {
                            if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
                                showGoogleAds()
                            }
                        }
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.imageviewLikeDislikeIcon.isHidden = true
        }
        isBackFromDetailScreen = false
    }
    
    func showGoogleAds() {
        let nativeadvc = NativeAdViewVC.loadFromNib()
        nativeadvc.isFromDiscoveryScreen = true
        nativeadvc.modalPresentationStyle = .fullScreen
        self.present(nativeadvc, animated: false)
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
    
    //MARK: Button Undo Activity Tap
    @objc func buttonUndoActivityRap(_ sender: UIButton) {
        if Constants.loggedInUser?.isPremiumUser == isPremium.Premium {
            viewActivityCard.revertAction()
        } else{
            showSubscriptionPlanScreen()
        }
    }
    
    //MARK: Button User Details Activity Tap
    @objc func buttonActivityUserDetailsTap(_ sender: UIButton) {
        let obj = self.viewModel.arrOtherActivities[sender.tag]
        let otheruseractivityvc = OtherUserActivityDetailsVC.loadFromNib()
        otheruseractivityvc.activity_id = "\(obj.id ?? 0)"
        otheruseractivityvc.objActivityDetails = obj
        
        otheruseractivityvc.callbackForIsLiked = { isLiked in
            self.isBackFromDetailScreen = true
            if isLiked {
                self.viewActivityCard.swipe(.up)
            } else {
                self.viewActivityCard.swipe(.down)
            }
        }
        
        otheruseractivityvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(otheruseractivityvc, animated: true)
    }
    
    //MARK: Button Owner User Details Activity Tap
    @objc func buttonOwnerUserDetailsTap(_ sender: UIButton) {
        let obj = self.viewModel.arrOtherActivities[sender.tag]
        viewModel.callGetUserDetailsAPI(user_id: obj.userId ?? 0)
    }
}
//MARK: Extension UDF
extension DiscoverActivityVC: GADFullScreenContentDelegate {
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        
        print("Ad did fail to present full screen content.")
//        if viewModel.getLikesLimit() != 0 {
//            if !isLikeLimitFinish {
//                if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
//                    print("Ad did fail to present full screen content.")
//                    self.showAlertPopup(message: Constants.alertMsg_noAdsAvailable)
//                }
//            }
//        }
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
