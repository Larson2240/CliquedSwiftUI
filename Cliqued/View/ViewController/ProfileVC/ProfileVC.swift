//
//  ProfileVC.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit
import SwiftUI

class ProfileVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewTopButtons: UIView!
    @IBOutlet weak var viewProfileCollection: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var pageviewcontrol: UIPageControl!
    @IBOutlet weak var labelUserNameAndAge: UILabel!{
        didSet {
            labelUserNameAndAge.font = CustomFont.THEME_FONT_Bold(19)
            labelUserNameAndAge.textColor = Constants.color_white
        }
    }
    @IBOutlet weak var labelLocationDistance: UILabel!{
        didSet {
            labelLocationDistance.font = CustomFont.THEME_FONT_Bold(19)
            labelLocationDistance.textColor = Constants.color_white
        }
    }
    
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
    var dataSource : ProfileDataSource?
    lazy var viewModel = ProfileViewModel()
    var objUserDetails: User?
    var isProfileDataload: Bool = false
    
    var favoriteActivity = [UserInterestedCategory]()
    var favoriteCategoryActivity = [UserInterestedCategory]()
    private let profileSetupType = ProfileSetupType()
    
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
        viewModel.bindActivityUserDetailsData()
        setupUserDetails()
        checkProfileCompletedOrNot()
    }
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonCompleteProfile, buttonTitle: Constants.btn_completeProfile)
    }
    
    //MARK: Button Safety Icon Click
    @IBAction func btnSafetyClick(_ sender: Any) {
        let editprofilevc = EditProfileVC.loadFromNib()
        editprofilevc.callbackForUpdateProfile = { [weak self] isUpdate in
            guard let self = self else { return }
            
            if isUpdate {
                self.tableview.reloadData()
                self.setupUserDetails()
            }
        }
        editprofilevc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editprofilevc, animated: true)
    }
    
    //MARK: Button complete profile tap
    @IBAction func btnCompleteProfileTap(_ sender: Any) {
        manageSetupProfileNavigationFlow()
    }

    //MARK: Button Settings Icon Click
    @IBAction func btnSettingsClick(_ sender: Any) {
        let settingsvc = SettingsVC.loadFromNib()
        settingsvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingsvc, animated: true)
    }
}
//MARK: Extension UDF
extension ProfileVC {
    
    func viewDidLoadMethod() {
        dataSource = ProfileDataSource(tableView: tableview, collectionView: collectionview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        collectionview.delegate = dataSource
        collectionview.dataSource = dataSource
        
        //Refresh Screen after edit project info
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen(_:)), name: Notification.Name("refreshProfileData"), object: nil)
    }
    //Refresh Screen
    @objc func refreshScreen(_ notification: NSNotification) {
        viewModel.bindActivityUserDetailsData()
        setupUserDetails()
        self.collectionview.reloadData()
        self.tableview.reloadData()
    }
    func setupUserDetails() {
        let name = viewModel.getName()
        let age = viewModel.getAge()
        let city = viewModel.getLocation().first?.city
        labelUserNameAndAge.text = "\(name), \(age)"
        labelLocationDistance.text = city
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
                self.collectionview.reloadData()
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
    func checkProfileCompletedOrNot() {
        if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
            self.viewProfileNotComplete.isHidden = true
            self.viewTopButtons.isHidden = false
            self.viewProfileCollection.isHidden = false
            self.tableview.isHidden = false
        } else {
            bindUserDetailsData()
            self.viewTopButtons.isHidden = true
            self.viewProfileCollection.isHidden = true
            self.tableview.isHidden = true
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
        case profileSetupType.name:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NameView())
            
        case profileSetupType.birthdate:
            APP_DELEGATE.window?.rootViewController =  UIHostingController(rootView: AgeView())
            
        case profileSetupType.gender:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: GenderView())
            
        case profileSetupType.relationship:
            let relationshipvc = RelationshipVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: relationshipvc)
            
        case profileSetupType.category:
            let pickactivityvc = PickActivityVC.loadFromNib()
            pickactivityvc.arrayOfActivity = self.favoriteActivity
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: pickactivityvc)
            
        case profileSetupType.sub_category:
            let picksubactivityvc = PickSubActvityVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: picksubactivityvc)
            
        case profileSetupType.profile_images:
            let selectpicturevc = SelectPicturesVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: selectpicturevc)
            
        case profileSetupType.location:
            let locationvc = SetLocationVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: locationvc)
            
        case profileSetupType.notification_enable:
            let notificationvc = NotificationPermissionVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: notificationvc)
            
        case profileSetupType.completed:
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
