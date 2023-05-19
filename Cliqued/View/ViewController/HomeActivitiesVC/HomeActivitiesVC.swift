//
//  HomeActivitiesVC.swift
//  Cliqued
//
//  Created by C211 on 18/01/23.
//

import UIKit
import Koloda
import SDWebImage
import GoogleMobileAds

private var numberOfCards: Int = 7

class HomeActivitiesVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var viewActivityCard: KolodaView!{
        didSet {
            viewActivityCard.layer.cornerRadius = 50.0
        }
    }
    @IBOutlet weak var imageviewLikeDislikeIcon: UIImageView!
    @IBOutlet weak var cardView: ActivityView!
    
    
    @IBOutlet weak var labelNoActivityAvailable: UILabel!{
        didSet {
            labelNoActivityAvailable.font = CustomFont.THEME_FONT_Medium(14)
            labelNoActivityAvailable.textColor = Constants.color_MediumGrey
        }
    }
    //MARK: Variable
    lazy var viewModel = HomeActivitiesViewModel()
    var objOfHomeCategory: ActivityCategoryClass?
    var arrayOfSubActivityIds = [Int]()
    var arrayOfLookingForIds = [Int]()
    var isUndoData: Bool = false
    var isBackFromDetailScreen: Bool = false
    private var interstitial: GADInterstitialAd?
    
    var user_ids = ""
    var isLikeLimitFinish: Bool = false
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
//MARK: Extension UDF
extension HomeActivitiesVC {
    
    func viewDidLoadMethod() {
        viewModel.setUserIds(value: user_ids)
        setupNavigationBar()
        setupKolodaCard()
        callGetUserActivityAPI()
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = user_ids == "" ? objOfHomeCategory?.title : Constants_Message.title_user_who_liked_me_text
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
        guidemanagervc.isFromUserSwipeScreen = true
        self.navigationController?.pushViewController(guidemanagervc, animated: false)
    }
    //MARK: Setup Koloda Card
    func setupKolodaCard() {
        viewActivityCard.backgroundCardsTopMargin = 0.0
        viewActivityCard.dataSource = self
        viewActivityCard.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    //MARK: Setup API Data & Call API
    func callGetUserActivityAPI() {
        var arrayOfSubCat = [SubCategory]()
        if objOfHomeCategory?.subCategory?.count ?? 0 > 0 {
            arrayOfSubCat = (objOfHomeCategory?.subCategory)!
            for i in arrayOfSubCat {
                self.arrayOfSubActivityIds.append(i.id ?? 0)
            }
        }
        let commaSepSubActivityIds = arrayOfSubActivityIds.map{String($0)}.joined(separator: ",")
        
        var arrayOfUserPreference = [UserPreferences]()
        arrayOfUserPreference = (Constants.loggedInUser?.userPreferences)!
        if arrayOfUserPreference.count > 0 {
            for i in arrayOfUserPreference {
                if i.typesOfPreference == PreferenceTypeIds.looking_for {
                    self.arrayOfLookingForIds.append(i.id ?? 0)
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
        
        viewModel.setActivityId(value: objOfHomeCategory?.id?.description ?? "")
        viewModel.setActivitySubCatIds(value: commaSepSubActivityIds)
        viewModel.setLookingForIds(value: commaSepLookingForIds)
        viewModel.setKidsOptionId(value: commaSepKids)
        viewModel.setSmokingOptionId(value: commaSepSmoke)
        viewModel.setAgeStartPrefId(value: commaSepAgeStart)
        viewModel.setAgeEndPrefId(value: commaSepAgeEnd)
        viewModel.setDistancePrefId(value: commaSepDistance)
        viewModel.callGetUserActivityAPI()
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
                self.viewActivityCard.countOfVisibleCards = self.viewModel.getNumberOfDuplicateUserActivity()
                self.viewActivityCard.reloadData()
            }
        }
        
        viewModel.isViewLimitFinish.bind { isSuccess in
            if isSuccess {
                if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
                    self.showSubscriptionPlanScreen()
                    self.labelNoActivityAvailable.text = Constants.label_noDataFound
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
        
        viewModel.isLikdDislikeSuccess.bind { isSuccess in
            if isSuccess {
                let followersData = self.viewModel.getFollowersData(at: 0)
                if followersData.isMeetup == isMeetup.Matched  {
                    let matchscreenvc = MatchScreenVC.loadFromNib()
                    matchscreenvc.arrayOfFollowers = self.viewModel.getAllFollowersData()
                    matchscreenvc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(matchscreenvc, animated: true)
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
extension HomeActivitiesVC: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
        if viewModel.getLikesLimit() != 0 {
            viewModel.arrayOfDuplicateUserList.removeAll()
        }
        if viewModel.getAllDuplicationUserActivityData().count == 0 {
            viewActivityCard.isHidden = true
            labelNoActivityAvailable.isHidden = false
            labelNoActivityAvailable.text = Constants.label_noDataFound
        }
    }
    
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
    }
}

//MARK: Extension for Koloda DataSource Method
extension HomeActivitiesVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        if !viewModel.isCheckEmptyData() {
            return viewModel.getNumberOfDuplicateUserActivity()
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
            let card = ActivityView()
            
            //Checking user is premium or not for undo activity
            let activityData = viewModel.getDuplicateUserActivityData(at: index)
            card.labelUserNameAndAge.text = "\(activityData.name ?? ""), \(activityData.age ?? 0)"
            
            let distance = activityData.distanceInkm!.clean
            card.labelLocationDistance.text = "\(distance) \(Constants.label_kmAway)"
            
            if let arr = activityData.userProfileImages, arr.count > 0 {
                let isImageData = arr.filter({$0.mediaType == "0"})
                let img = isImageData[0].url
                let strUrl = UrlProfileImage + img!
                let imageWidth = card.imageview.frame.size.width
                let imageHeight = card.imageview.frame.size.height
                let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth)&h=\(imageHeight)&zc=1&src=\(strUrl)"
                let url = URL(string: baseTimbThumb)
                card.imageview.sd_imageIndicator = SDWebImageActivityIndicator.gray
                card.imageview.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_swipecard"), options: .refreshCached, context: nil)
            }
            card.buttonUserInfo.tag = index
            card.buttonLike.tag = index
            card.buttonDislike.tag = index
            card.buttonUndo.tag = index
            
            if user_ids == "" {
                card.buttonUndo.isHidden =  false
            } else {
                card.buttonUndo.isHidden = true
            }
            
            card.buttonUserInfo.addTarget(self, action: #selector(buttonActivityUserDetailsTap(_:)), for: .touchUpInside)
            card.buttonUndo.addTarget(self, action: #selector(buttonUndoActivityRap(_:)), for: .touchUpInside)
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
        
        print(finishPercentage)
        
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
                if viewModel.getAllDuplicationUserActivityData().count > 0 {
                    let activityData = viewModel.getDuplicateUserActivityData(at: index)
                    viewModel.setCounterUserId(value: "\(activityData.id ?? 0)")
                    viewModel.setIsFollow(value: "1")
                    viewModel.callLikeDislikeUserAPI(isShowLoader: false)
                    
//                    if viewModel.getLikesLimit() != 0 {
//                        if !isLikeLimitFinish {
//                            if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
//                                showGoogleAds()
//                            }
//                        }
//                    }
                }
            } else if direction == .down || direction == .bottomLeft || direction == .bottomRight {
                if viewModel.getAllDuplicationUserActivityData().count > 0 {
                    let activityData = viewModel.getDuplicateUserActivityData(at: index)
                    viewModel.setCounterUserId(value: "\(activityData.id ?? 0)")
                    viewModel.setIsFollow(value: "0")
                    viewModel.callLikeDislikeUserAPI(isShowLoader: false)
                    
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
        nativeadvc.screenTitle = user_ids == "" ? objOfHomeCategory?.title : Constants_Message.title_user_who_liked_me_text
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
        let activityuserdetailsvc = ActivityUserDetailsVC.loadFromNib()
        let activityData = viewModel.getDuplicateUserActivityData(at: sender.tag)
        activityuserdetailsvc.objUserDetails = activityData
        
        activityuserdetailsvc.callbackForIsLiked = { isLiked in
            self.isBackFromDetailScreen = true
            if isLiked {
                self.viewActivityCard.swipe(.up)
            } else {
                self.viewActivityCard.swipe(.down)
            }
        }
        
        activityuserdetailsvc.callbackForBlockUser = { isblocked in
            self.isBackFromDetailScreen = true
            if isblocked {
                self.viewActivityCard.swipe(.up)
            }
        }
        
        activityuserdetailsvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(activityuserdetailsvc, animated: true)
    }
}
