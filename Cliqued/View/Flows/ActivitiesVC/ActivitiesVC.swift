//
//  ActivitiesVC.swift
//  Cliqued
//
//  Created by C211 on 11/01/23.
//

import UIKit
import SwiftUI

class ActivitiesVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var viewProfileNotComplete: UIView!
    @IBOutlet weak var labelProfileMsg: UILabel!{
        didSet{
            labelProfileMsg.text = Constants.validMsg_profileIncompleteMsg
            labelProfileMsg.font = CustomFont.THEME_FONT_Medium(14)
            labelProfileMsg.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonCompleteProfile: UIButton!
    
    //MARK: Variable
    var dataSource : ActivitiesDataSource?
    lazy var viewModel = ActivitiesViewModel()
    private let preferenceTypeIds = PreferenceTypeIds()
    private let profileSetupType = ProfileSetupType()
    
    var favoriteActivity = [UserInterestedCategory]()
    var favoriteCategoryActivity = [UserInterestedCategory]()
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        if isProfileCompleted() {
            self.viewModel.setUserId(value: "\(Constants.loggedInUser?.id ?? 0)")
            
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
                    if i.typesOfPreference == preferenceTypeIds.looking_for {
                        arrayOfLookingForIds.append(i.id ?? 0)
                    }
                }
            }
            let commaSepLookingForIds = arrayOfLookingForIds.map{String($0)}.joined(separator: ",")
            
            var arrayDistancePreference = [Int]()
            if arrayOfUserPreference.count > 0 {
                for i in arrayOfUserPreference {
                    if i.typesOfPreference == preferenceTypeIds.distance {
                        arrayDistancePreference.append(i.preferenceOptionId ?? 0)
                    }
                }
            }
            let commaSepDistance = arrayDistancePreference.map{String($0)}.joined(separator: ",")
            
            var arrayKidsPreference = [Int]()
            if arrayOfUserPreference.count > 0 {
                for i in arrayOfUserPreference {
                    if i.typesOfPreference == preferenceTypeIds.kids {
                        arrayKidsPreference.append(i.preferenceOptionId ?? 0)
                    }
                }
            }
            let commaSepKids = arrayKidsPreference.map{String($0)}.joined(separator: ",")
            
            var arraySmokePreference = [Int]()
            if arrayOfUserPreference.count > 0 {
                for i in arrayOfUserPreference {
                    if i.typesOfPreference == preferenceTypeIds.smoking {
                        arraySmokePreference.append(i.preferenceOptionId ?? 0)
                    }
                }
            }
            let commaSepSmoke = arraySmokePreference.map{String($0)}.joined(separator: ",")
            
            var arrayAgeStartPreference = [Int]()
            if arrayOfUserPreference.count > 0 {
                for i in arrayOfUserPreference {
                    if i.subTypesOfPreference == preferenceTypeIds.age_start {
                        arrayAgeStartPreference.append(i.preferenceOptionId ?? 0)
                    }
                }
            }
            let commaSepAgeStart = arrayAgeStartPreference.map{String($0)}.joined(separator: ",")
            
            var arrayAgeEndPreference = [Int]()
            if arrayOfUserPreference.count > 0 {
                for i in arrayOfUserPreference {
                    if i.subTypesOfPreference == preferenceTypeIds.age_end {
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
            self.viewModel.setOffset(value: "0")
            self.viewModel.callAllActivityListAPI()
        }
    }
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonCompleteProfile, buttonTitle: Constants.btn_completeProfile)
    }
    
    //MARK: Button complete profile tap
    @IBAction func btnCompleteProfileTap(_ sender: Any) {
        manageSetupProfileNavigationFlow()
    }
}
//MARK: Extension UDF
extension ActivitiesVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = ActivitiesDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        handleApiResponse()
    }
    
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_activities
        viewNavigationBar.buttonBack.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
        viewNavigationBar.buttonRight.isHidden = false
        viewNavigationBar.buttonRight.addTarget(self, action: #selector(buttonGuideTap), for: .touchUpInside)
    }
    //MARK: Back Button Action
    @objc func buttonGuideTap() {
        let guidemanagervc = GuideManagerVC.loadFromNib()
        guidemanagervc.isFromActivitiesScreen = true
        guidemanagervc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(guidemanagervc, animated: false)
    }
    
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                               
                self.tableview.reloadData()
                self.dataSource!.hideHeaderLoader()
            }
        }
        
        //Loader hide & show
        viewModel.isLoaderShow.bind { [weak self] isLoader in
            guard let self = self else { return }
            
            if isLoader {
                self.showLoader()
            } else {
                self.dismissLoader()
            }
        }
    }
    //MARK: Function manage if user profile not complete
    func isProfileCompleted() -> Bool {
        if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
            self.viewProfileNotComplete.isHidden = true
            viewNavigationBar.buttonRight.isHidden = false
            self.tableview.isHidden = false
            return true
        } else {
            bindUserDetailsData()
            viewNavigationBar.buttonRight.isHidden = true
            self.tableview.isHidden = true
            self.viewProfileNotComplete.isHidden = false
            return false
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
        case profileSetupType.name:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NameView())
            
        case profileSetupType.birthdate:
            APP_DELEGATE.window?.rootViewController =  UIHostingController(rootView: AgeView())
            
        case profileSetupType.gender:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: GenderView())
            
        case profileSetupType.relationship:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: RelationshipView(isFromEditProfile: false))
            
        case profileSetupType.category:
            let pickActivityView = PickActivityView(isFromEditProfile: false, arrayOfActivity: favoriteActivity)
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: pickActivityView)
            
        case profileSetupType.sub_category:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: PickSubActivityView(isFromEditProfile: false, categoryIds: "", arrayOfSubActivity: []))
            
        case profileSetupType.profile_images:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: SelectPicturesView(arrayOfProfileImage: [], isFromEditProfile: false))
            
        case profileSetupType.location:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: LocationView(isFromEditProfile: false, addressId: "", setlocationvc: ""))
            
        case profileSetupType.notification_enable:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NotificationsView())
            
        case profileSetupType.completed:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView(selectionValue: 0))
        default:
            break
        }
    }
    
    //MARK: Bind data on screen from the user object.
    func bindUserDetailsData() {
        let userData = Constants.loggedInUser!
        
        if userData.userInterestedCategory?.count ?? 0 > 0 {
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
