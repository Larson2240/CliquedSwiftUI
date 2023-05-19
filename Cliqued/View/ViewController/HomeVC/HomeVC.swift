//
//  HomeVC.swift
//  Cliqued
//
//  Created by C211 on 11/01/23.
//

import UIKit

class HomeVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var viewProfileNotComplete: UIView!
    @IBOutlet weak var labelProfileMsg: UILabel!{
        didSet{
            labelProfileMsg.text = Constants.validMsg_profileIncompleteMsg
            labelProfileMsg.font = CustomFont.THEME_FONT_Medium(14)
            labelProfileMsg.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonCompleteProfile: UIButton!
    @IBOutlet weak var buttonGuidManager: UIButton!
    
    //MARK: Variable
    var dataSource: HomeDataSource?
    lazy var viewModel = HomeViewModel()
    lazy var vieWModelMessage = MessageViewModel()
    var isCategoryNotEmpty: Bool = false
    var favoriteActivity = [UserInterestedCategory]()
    var favoriteCategoryActivity = [UserInterestedCategory]()
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageReload(notification:)), name: .languageChange, object: nil)
        
    }
    
    @objc func languageReload(notification: NSNotification) {
        self.view.layoutIfNeeded()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        isProfileCompleted()
    }
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonCompleteProfile, buttonTitle: Constants.btn_completeProfile)
    }
    
    //MARK: Button guid manager tap
    @IBAction func btnGuidManagerTap(_ sender: Any) {
        let guidemanagervc = GuideManagerVC.loadFromNib()
        guidemanagervc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(guidemanagervc, animated: false)
    }
    
    //MARK: Button complete profile tap
    @IBAction func btnCompleteProfileTap(_ sender: Any) {
        manageSetupProfileNavigationFlow()
    }
}

//MARK: Extension UDF
extension HomeVC {
    
    func viewDidLoadMethod() {
        self.dataSource = HomeDataSource(viewController: self, viewModel: viewModel, collectionView: collectionview,viewModelMessage: vieWModelMessage)
        self.collectionview.delegate = dataSource
        self.collectionview.dataSource = dataSource
        self.viewModel.callGetPreferenceDataAPI()
        self.viewModel.callGetUserInterestedCategoryAPI()
        handleApiResponse()
        
        //Refresh Screen after edit project info
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen(_:)), name: Notification.Name("refreshProfileData"), object: nil)
    }
    
    //Refresh Screen
    @objc func refreshScreen(_ notification: NSNotification) {
        viewModel.callGetPreferenceDataAPI()
        self.viewModel.callGetUserInterestedCategoryAPI()
    }
    
    func checkPushNotificationEnabled() {
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    self.viewModel.callUpdateUserDeviceTokenAPI(is_enabled: false)
                    APP_DELEGATE.registerForPushNotifications()
                }
                // Notification permission has not been asked yet, go for it!
            } else if settings.authorizationStatus == .denied {
               
                DispatchQueue.main.async {
                    self.viewModel.callUpdateUserDeviceTokenAPI(is_enabled: false)
                }
               
                // Notification permission was previously denied, go to settings & privacy to re-enable
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                APP_DELEGATE.registerForPushNotifications()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.viewModel.callUpdateUserDeviceTokenAPI(is_enabled: true)
                }
            }
        })
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
                self.collectionview.reloadData()
                self.dataSource!.hideHeaderLoader()
            }
        }
    }
    
    //MARK: Function manage if user profile not complete
    func isProfileCompleted() {
        if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
            self.viewProfileNotComplete.isHidden = true
            self.buttonGuidManager.isHidden = false
            self.collectionview.isHidden = false
            checkPushNotificationEnabled()
        } else {
            bindUserDetailsData()
            self.buttonGuidManager.isHidden = true
            self.collectionview.isHidden = true
            self.viewProfileNotComplete.isHidden = false
        }
    }
    
    //MARK: Setup profile navigation flow
    func manageSetupProfileNavigationFlow() {
        let strCount: String?
        if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
            let profile_setup_count = Int((Constants.loggedInUser?.profileSetupType)!)!
            strCount = "\(profile_setup_count)"
        } else {
            let profile_setup_count = Int((Constants.loggedInUser?.profileSetupType)!)! + 1
            strCount = "\(profile_setup_count)"
        }
        switch strCount {
        case ProfileSetupType.name:
            let namevc = NameVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: namevc)
            
        case ProfileSetupType.birthdate:
            let agevc = AgeVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController =  UINavigationController(rootViewController: agevc)
            
        case ProfileSetupType.gender:
            let gendervc = GenderVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: gendervc)
            
        case ProfileSetupType.relationship:
            let relationshipvc = RelationshipVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: relationshipvc)
            
        case ProfileSetupType.category:
            let pickactivityvc = PickActivityVC.loadFromNib()
            pickactivityvc.arrayOfActivity = self.favoriteActivity
//            pickactivityvc.isFromSetupProfile = isCategoryNotEmpty
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: pickactivityvc)
            
        case ProfileSetupType.sub_category:
            let picksubactivityvc = PickSubActvityVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: picksubactivityvc)
            
        case ProfileSetupType.profile_images:
            let selectpicturevc = SelectPicturesVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: selectpicturevc)
            
        case ProfileSetupType.location:
            let locationvc = SetLocationVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: locationvc)
            
        case ProfileSetupType.notification_enable:
            let notificationvc = NotificationPermissionVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: notificationvc)
            
        case ProfileSetupType.completed:
            let tabbarvc = TabBarVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: tabbarvc)
        default:
            break
        }
    }
    
    //MARK: Bind data on screen from the user object.
    func bindUserDetailsData() {
        let userData = Constants.loggedInUser!
        
        if userData.userInterestedCategory?.count ?? 0 > 0 {
            self.isCategoryNotEmpty = true
            if let interestedActivity = userData.userInterestedCategory {
                self.favoriteActivity = interestedActivity
            }
        }

        //MARK: Managed multiple same category object in one category object
        var arrayOfActivityIds = [Int]()
        if userData.userInterestedCategory?.count ?? 0 > 0 {
            for interestedCategoryData in userData.userInterestedCategory ?? [] {
                if let activityId = interestedCategoryData.activityId {
                    arrayOfActivityIds.append(activityId)
                }
            }
        }
        for activityId in arrayOfActivityIds {
            if let data = self.favoriteActivity.filter({$0.activityId == activityId}).first {
                if !self.favoriteActivity.contains(where: {$0.activityId == activityId}) {
                    self.favoriteCategoryActivity.append(data)
                }
            }
        }
    }
}
