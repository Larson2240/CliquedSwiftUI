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
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: RelationshipView(isFromEditProfile: false, arrayOfUserPreference: []))
            
        case profileSetupType.category:
            let pickActivityView = PickActivityView(isFromEditProfile: false, arrayOfActivity: favoriteActivity, activitiesFlowPresented: .constant(false))
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: pickActivityView)
            
        case profileSetupType.sub_category:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: PickSubActivityView(isFromEditProfile: false, categoryIds: "", arrayOfSubActivity: [], activitiesFlowPresented: .constant(false)))
            
        case profileSetupType.profile_images:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: SelectPicturesView(arrayOfProfileImage: [], isFromEditProfile: false))
            
        case profileSetupType.location:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: LocationView(isFromEditProfile: false, addressId: ""))
            
        case profileSetupType.notification_enable:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NotificationsView())
            
        case profileSetupType.completed:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView())
        default:
            break
        }
    }
    
    //MARK: Bind data on screen from the user object.
    func bindUserDetailsData() {
        let userData = Constants.loggedInUser!
        
    }
}
