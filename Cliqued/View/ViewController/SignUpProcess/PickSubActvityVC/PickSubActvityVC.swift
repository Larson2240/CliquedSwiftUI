//
//  PickSubActvityVC.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class PickSubActvityVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_pickSubActivityScreenTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelSubTitle: UILabel!{
        didSet {
            labelSubTitle.text = Constants.label_pickSubActivityScreenSubTitle
            labelSubTitle.font = CustomFont.THEME_FONT_Book(14)
            labelSubTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var buttonContinue: UIButton!
    
    //MARK: Variable
    var dataSource: PickSubActivityDataSource?
    lazy var viewModel = PickSubActivityViewModel()
    lazy var viewModelSignUpProcess = SignUpProcessViewModel()
    var isSubCatSelectedFromEveryCategory: Bool = false
    var arrayOfSubActivity = [UserInterestedCategory]()
    var isFromEditProfile: Bool = false
    var isFromSetupProfile: Bool = false
    var isAnimationDone: Bool = true
    var callbackForBackToCategory: ((_ isBackFromSubCat: Bool) -> Void)?
    var categoryIds: String = ""
    
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
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
        if isAnimationDone {
            labelMainTitle.lastLineFillPercent = 100
            labelMainTitle.linesCornerRadius = 10
            labelMainTitle.skeletonTextNumberOfLines = 1
            labelMainTitle.skeletonTextLineHeight = .fixed(30)
            
            labelSubTitle.lastLineFillPercent = 70
            labelSubTitle.linesCornerRadius = 10
            labelSubTitle.skeletonTextNumberOfLines = 1
            labelSubTitle.skeletonTextLineHeight = .fixed(30)
            
            labelMainTitle.showAnimatedGradientSkeleton()
            labelSubTitle.showAnimatedGradientSkeleton()
            
            labelMainTitle.layoutSkeletonIfNeeded()
            labelSubTitle.layoutSkeletonIfNeeded()
        }
    }

    //MARK: Button Continue Click Event
    @IBAction func btnContinueTap(_ sender: Any) {
        for i in viewModel.getActivityAllData() {
            if viewModel.getSelectedSubActivity().firstIndex(where: { $0.activityCategoryId == "\(i.id ?? 0)"}) != nil {
                self.isSubCatSelectedFromEveryCategory = true
            } else {
                self.isSubCatSelectedFromEveryCategory = false
                break
            }
        }
        if isSubCatSelectedFromEveryCategory {
            viewModelSignUpProcess.setActivity(value: viewModel.convertSubActivityStructToString())
            if !isFromEditProfile {
                viewModelSignUpProcess.setProfileSetupType(value: ProfileSetupType.sub_category)
            } else {
                if isFromSetupProfile {
                    viewModelSignUpProcess.setProfileSetupType(value: ProfileSetupType.sub_category)
                } else {
                    viewModelSignUpProcess.setProfileSetupType(value: ProfileSetupType.completed)
                }
            }
            viewModelSignUpProcess.callSignUpProcessAPI()
        } else {
            self.showAlertPopup(message: Constants.validMsg_pickSubActivity)
        }
        print("New Activity: \(viewModel.convertNewSubActivityStructToString())")
        print("Deleted Activity: \(viewModel.getDeletedSubActivityIds())")
    }
    
}
//MARK: Extension UDF
extension PickSubActvityVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupProgressView()
        self.dataSource = PickSubActivityDataSource(viewController: self, collectionView: collectionview, viewModel: viewModel)
        self.collectionview.delegate = dataSource
        self.collectionview.dataSource = dataSource
        self.viewModel.setCategoriesIds(value: categoryIds)
        self.viewModel.callGetActivityDataAPI()
        self.handleApiResponse()
        if isFromEditProfile {
            setupSelectedSubActivity()
        }
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_pickSubactivity
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonSkip.addTarget(self, action: #selector(buttonSkipTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        
        if !isFromEditProfile {
            progressView.isHidden = false
            viewNavigationBar.buttonRight.isHidden = true
            viewNavigationBar.buttonSkip.isHidden = false
        } else {
            viewNavigationBar.buttonRight.isHidden = true
            if self.isFromSetupProfile {
                progressView.isHidden = false
                viewNavigationBar.buttonSkip.isHidden = false
            } else {
                progressView.isHidden = true
                viewNavigationBar.buttonSkip.isHidden = true
            }
        }
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.callbackForBackToCategory?(true)
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Back Skip Action
    @objc func buttonSkipTap() {
        APP_DELEGATE.setTabBarRootViewController()
    }
    //MARK: Setup ProgressView progress
    func setupProgressView() {
        let currentProgress = 6
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
    //MARK: Hide skeleton animation
    func hideAnimation() {
        self.labelMainTitle.hideSkeleton()
        self.labelSubTitle.hideSkeleton()
        self.isAnimationDone = false
    }
    //MARK: Manage sub activity collection for edit time
    func setupSelectedSubActivity() {
        for activityData in arrayOfSubActivity {
            if viewModel.getSelectedSubActivity().contains(where: { $0.activityCategoryId == "\(activityData.activityId ?? 0)" && $0.activitySubCategoryId == "\(activityData.subActivityId ?? 0)"}) == false {
                var dic = structPickSubActivityParams()
                dic.activityCategoryId = "\(activityData.activityId ?? 0)"
                dic.activitySubCategoryId = "\(activityData.subActivityId ?? 0)"
                self.viewModel.setSubActivity(value: dic)
                self.viewModel.setAllSelectedSubActivity(value: dic)
            }
        }
        self.collectionview.reloadData()
    }
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { message in
            self.showAlertPopup(message: message)
        }
        viewModelSignUpProcess.isMessage.bind { message in
            self.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isActivityDataGet.bind { isSuccess in
            if isSuccess {
                self.collectionview.reloadData()
            }
        }
        //If API success
        viewModelSignUpProcess.isDataGet.bind { isSuccess in
            if isSuccess {
                if self.isFromEditProfile {
                    if self.isFromSetupProfile {
                        let selectpictureVC = SelectPicturesVC.loadFromNib()
                        self.navigationController?.pushViewController(selectpictureVC, animated: true)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("refreshProfileData"), object: nil, userInfo:nil)
                        let editprofilevc = EditProfileVC.loadFromNib()
                        editprofilevc.isUpdateData = true
                        self.navigationController?.pushViewController(editprofilevc, animated: true)
                    }
                } else {
                    let selectpictureVC = SelectPicturesVC.loadFromNib()
                    self.navigationController?.pushViewController(selectpictureVC, animated: true)
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
        //Loader hide & show
        viewModelSignUpProcess.isLoaderShow.bind { isLoader in
            if isLoader {
                self.showLoader()
            } else {
                self.dismissLoader()
            }
        }
    }
}
