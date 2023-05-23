//
//  PickActivityVC.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class PickActivityVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_pickActivityScreenTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelSubTitle: UILabel!{
        didSet {
            labelSubTitle.text = Constants.label_pickActivityScreenSubTitle
            labelSubTitle.font = CustomFont.THEME_FONT_Book(14)
            labelSubTitle.textColor = Constants.color_DarkGrey
            
        }
    }
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var buttonContinue: UIButton!
    
    
    //MARK: Variable
    var dataSource: PickActivityDataSource?
    lazy var viewModel = PickActivityViewModel()
    lazy var viewModelSignUpProcess = SignUpProcessViewModel()
    
    var isFromEditProfile: Bool = false
    var isFromSetupProfile: Bool = false
    var arrayOfActivity = [UserInterestedCategory]()
    var isAnimationDone: Bool = true
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let arrayCategory = Constants.loggedInUser?.userInterestedCategory
        self.viewModel.removeAllSelectedActivity()
        for activityData in arrayCategory ?? [] {
            var dic = structPickActivityParams()
            dic.activityCategoryId = "\(activityData.activityId ?? 0)"
            dic.activitySubCategoryId = "0"
            self.viewModel.setAllSelectedActivity(value: dic)
        }
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
        if self.viewModel.getSelectedCategoryId().count >= 3 {
            if self.isFromEditProfile {
                let categoryIds = viewModel.getSelectedCategoryId().map({String($0)}).joined(separator: ", ")
                
                //Remove deleted activity from the edit array
                let deletedIds = self.viewModel.getDeletedActivityIds()
                var arrFilteredIds = self.arrayOfActivity
                
                for i in 0..<deletedIds.count {
                    let arr1 = arrFilteredIds.filter({$0.activityId == deletedIds[i]})

                    if arr1.count > 0 {
                        
                        let sub_cat_array = arr1.map({$0.subActivityId})
                        
                        for j in 0..<arr1.count {
                            if let index = arrFilteredIds.firstIndex(where: {$0.activityId == deletedIds[i] && $0.subActivityId == sub_cat_array[j]}) {
                                arrFilteredIds.remove(at: index)
                            }
                        }
                    }
                }
                let picksubactivityvc = PickSubActvityVC.loadFromNib()
                if self.isFromSetupProfile {
                    picksubactivityvc.isFromEditProfile = false
                } else {
                    picksubactivityvc.isFromEditProfile = true
                }
                picksubactivityvc.categoryIds = categoryIds
                picksubactivityvc.arrayOfSubActivity = arrFilteredIds
                self.navigationController?.pushViewController(picksubactivityvc, animated: true)
            } else {
                let categoryIds = viewModel.getSelectedCategoryId().map({String($0)}).joined(separator: ", ")
                let picksubactivityvc = PickSubActvityVC.loadFromNib()
                picksubactivityvc.categoryIds = categoryIds
                self.navigationController?.pushViewController(picksubactivityvc, animated: true)
            }
        } else {
            self.showAlertPopup(message: Constants.validMsg_pickActivity)
        }
    }
}
//MARK: Extension UDF
extension PickActivityVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupProgressView()
        self.dataSource = PickActivityDataSource(viewController: self, collectionView: collectionview, viewModel: viewModel)
        self.collectionview.delegate = dataSource
        self.collectionview.dataSource = dataSource
        self.viewModel.callGetActivityDataAPI()
        self.handleApiResponse()
        if isFromEditProfile {
            setupSelectedActivity()
        }
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_pickActivity
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonSkip.addTarget(self, action: #selector(buttonSkipTap), for: .touchUpInside)
        
        
        if !isFromEditProfile {
            progressView.isHidden = false
            viewNavigationBar.buttonBack.isHidden = true
            viewNavigationBar.buttonRight.isHidden = true
            viewNavigationBar.buttonSkip.isHidden = false
        } else {
            progressView.isHidden = true
            viewNavigationBar.buttonBack.isHidden = false
            viewNavigationBar.buttonRight.isHidden = true
            viewNavigationBar.buttonSkip.isHidden = true
        }
        
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Back Skip Action
    @objc func buttonSkipTap() {
        APP_DELEGATE.setTabBarRootViewController()
    }
    //MARK: Setup ProgressView progress
    func setupProgressView() {
        let currentProgress = 5
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
    //MARK: Hide skeleton animation
    func hideAnimation() {
        self.labelMainTitle.hideSkeleton()
        self.labelSubTitle.hideSkeleton()
        self.isAnimationDone = false
    }
    //MARK: Manage activity collection for edit time
    func setupSelectedActivity() {
        self.viewModel.removeAllSelectedArray()
        for activityData in arrayOfActivity {
            if viewModel.getSelectedCategoryId().contains(where: {$0 == activityData.activityId}) == false {
                self.viewModel.setSelectedCategoryId(value: activityData.activityId ?? 0)
            }
        }
        self.collectionview.reloadData()
    }
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isActivityDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                self.collectionview.reloadData()
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
}
