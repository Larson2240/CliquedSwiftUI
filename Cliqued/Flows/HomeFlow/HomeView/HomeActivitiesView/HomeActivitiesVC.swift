//
//  HomeActivitiesVC.swift
//  Cliqued
//
//  Created by C211 on 18/01/23.
//

import SwiftUI
import Koloda
import SDWebImage
import GoogleMobileAds

struct ActivitiesViewRepresentable: UIViewControllerRepresentable {
    var selectedActivity: Activity?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = HomeActivitiesVC.loadFromNib()
        vc.activity = selectedActivity
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

private var numberOfCards: Int = 7

final class HomeActivitiesVC: UIViewController {
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var viewActivityCard: KolodaView! {
        didSet {
            viewActivityCard.layer.cornerRadius = 50
        }
    }
    @IBOutlet weak var imageviewLikeDislikeIcon: UIImageView!
    @IBOutlet weak var cardView: ActivityView!
    
    @IBOutlet weak var labelNoActivityAvailable: UILabel! {
        didSet {
            labelNoActivityAvailable.font = CustomFont.THEME_FONT_Medium(14)
            labelNoActivityAvailable.textColor = Constants.color_MediumGrey
        }
    }
    
    //MARK: Variable
    lazy var viewModel = HomeActivitiesViewModel()
    var activity: Activity?
    var isUndoData: Bool = false
    var isBackFromDetailScreen: Bool = false
    private var interstitial: GADInterstitialAd?
    private let preferenceTypeIds = PreferenceTypeIds()
    private let isMeetup = IsMeetupIds()
    private let isPremium = IsPremium()
    
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
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
//MARK: Extension UDF
extension HomeActivitiesVC {
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupKolodaCard()
        
        if let activityID = activity?.id {
            viewModel.callGetUserActivityAPI(id: String(activityID))
        }
        
        handleApiResponse()
    }
    
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = user_ids == "" ? activity?.title : Constants_Message.title_user_who_liked_me_text
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
        
    }
    
    //MARK: Handle API response
    func handleApiResponse() {
        
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
        
    }
    
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
    }
}

//MARK: Extension for Koloda DataSource Method
extension HomeActivitiesVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 0
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.up, .down, .topLeft, .topRight, .bottomLeft, .bottomRight]
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
//        if !viewModel.isCheckEmptyData() {
//            let card = ActivityView()
//
//            //Checking user is premium or not for undo activity
//            let activityData = viewModel.getDuplicateUserActivityData(at: index)
////            card.labelUserNameAndAge.text = "\(activityData.name ?? ""), \(activityData.age ?? 0)"
////
////            let distance = activityData.preferenceDistance
////            card.labelLocationDistance.text = "\(distance) \(Constants.label_kmAway)"
//
//            if let arr = activityData.userProfileMedia, arr.count > 0 {
//                let isImageData = arr.filter({$0.mediaType == 0})
//                let img = isImageData[0].url
//                let strUrl = UrlProfileImage + img
//                let imageWidth = card.imageview.frame.size.width
//                let imageHeight = card.imageview.frame.size.height
//                let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth)&h=\(imageHeight)&zc=1&src=\(strUrl)"
//                let url = URL(string: baseTimbThumb)
//                card.imageview.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                card.imageview.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_swipecard"), options: .refreshCached, context: nil)
//            }
//            card.buttonUserInfo.tag = index
//            card.buttonLike.tag = index
//            card.buttonDislike.tag = index
//            card.buttonUndo.tag = index
//
//            if user_ids == "" {
//                card.buttonUndo.isHidden =  false
//            } else {
//                card.buttonUndo.isHidden = true
//            }
//
//            card.buttonUserInfo.addTarget(self, action: #selector(buttonActivityUserDetailsTap(_:)), for: .touchUpInside)
//            card.buttonUndo.addTarget(self, action: #selector(buttonUndoActivityRap(_:)), for: .touchUpInside)
//            card.buttonLike.addTarget(self, action: #selector(buttonLikeActivityTap(_:)), for: .touchUpInside)
//            card.buttonDislike.addTarget(self, action: #selector(buttonDislikeActivityTap(_:)), for: .touchUpInside)
//            return card
//        } else {
//            viewActivityCard.isHidden = true
//            labelNoActivityAvailable.isHidden = false
            return UIView()
//        }
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
//            if direction == .up || direction == .topLeft || direction == .topRight {
//                if viewModel.getAllDuplicationUserActivityData().count > 0 {
//                    let activityData = viewModel.getDuplicateUserActivityData(at: index)
////                    viewModel.setCounterUserId(value: "\(activityData.id ?? 0)")
//                    viewModel.setIsFollow(value: "1")
//                    viewModel.callLikeDislikeUserAPI(isShowLoader: false)
//
//                    //                    if viewModel.getLikesLimit() != 0 {
//                    //                        if !isLikeLimitFinish {
//                    //                            if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
//                    //                                showGoogleAds()
//                    //                            }
//                    //                        }
//                    //                    }
//                }
//            } else if direction == .down || direction == .bottomLeft || direction == .bottomRight {
//                if viewModel.getAllDuplicationUserActivityData().count > 0 {
//                    let activityData = viewModel.getDuplicateUserActivityData(at: index)
////                    viewModel.setCounterUserId(value: "\(activityData.id ?? 0)")
//                    viewModel.setIsFollow(value: "0")
//                    viewModel.callLikeDislikeUserAPI(isShowLoader: false)
//
//                    if viewModel.getLikesLimit() != 0 {
//                        if !isLikeLimitFinish {
////                            if Constants.loggedInUser?.isPremiumUser == isPremium.NotPremium {
////                                showGoogleAds()
////                            }
//                        }
//                    }
//                }
//            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.imageviewLikeDislikeIcon.isHidden = true
        }
        isBackFromDetailScreen = false
    }
    
    func showGoogleAds() {
        let nativeadvc = NativeAdViewVC.loadFromNib()
        nativeadvc.screenTitle = user_ids == "" ? activity?.title : Constants_Message.title_user_who_liked_me_text
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
//        if Constants.loggedInUser?.isPremiumUser == isPremium.Premium {
//            viewActivityCard.revertAction()
//        } else{
//            showSubscriptionPlanScreen()
//        }
    }
    
    //MARK: Button User Details Activity Tap
    @objc func buttonActivityUserDetailsTap(_ sender: UIButton) {
//        let activityuserdetailsvc = ActivityUserDetailsVC.loadFromNib()
//        let activityData = viewModel.getDuplicateUserActivityData(at: sender.tag)
//        activityuserdetailsvc.objUserDetails = activityData
//
//        activityuserdetailsvc.callbackForIsLiked = { [weak self] isLiked in
//            guard let self = self else { return }
//
//            self.isBackFromDetailScreen = true
//            if isLiked {
//                self.viewActivityCard.swipe(.up)
//            } else {
//                self.viewActivityCard.swipe(.down)
//            }
//        }
//
//        activityuserdetailsvc.callbackForBlockUser = { [weak self] isblocked in
//            guard let self = self else { return }
//
//            self.isBackFromDetailScreen = true
//            if isblocked {
//                self.viewActivityCard.swipe(.up)
//            }
//        }
//
//        activityuserdetailsvc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(activityuserdetailsvc, animated: true)
    }
}
