//
//  SetLocationVC.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit

class SetLocationVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_setLocationScreenSubTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonContinue: UIButton!
    
    //MARK: Variable
    var dataSource : SetLocationDataSource?
    lazy var viewModel = SignUpProcessViewModel()
    var isFromEditProfile: Bool = false
    var distancePreference = ""
    var addressId = ""
    var objAddress: UserAddress!
    
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
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
    }

    //MARK: Button Continue Click Event
    @IBAction func btnContinueTap(_ sender: Any) {
        if dataSource?.addressDic.latitude != "" && dataSource?.addressDic.longitude != "" && dataSource?.addressDic.city != "" && dataSource?.addressDic.state != "" {
            self.viewModel.setUserAddress(value: dataSource?.addressDic ?? structAddressParam())
            if !isFromEditProfile {
                viewModel.setProfileSetupType(value: ProfileSetupType.location)
            } else {
                viewModel.setProfileSetupType(value: ProfileSetupType.completed)
            }
            viewModel.callSignUpProcessAPI()
        } else {
            showAlertPopup(message: Constants.validMsg_validAddress)
        }
    }
}
//MARK: Extension UDF
extension SetLocationVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupProgressView()
        dataSource = SetLocationDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_setYourLocation
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
        let currentProgress = 8
        progressView.progress = Float(currentProgress)/Float(maxProgress)
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
                if !self.isFromEditProfile {
                    let notificationVC = NotificationPermissionVC.loadFromNib()
                    self.navigationController?.pushViewController(notificationVC, animated: true)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("refreshProfileData"), object: nil, userInfo:nil)
                    let editprofilevc = EditProfileVC.loadFromNib()
                    editprofilevc.isUpdateData = true
                    self.navigationController?.pushViewController(editprofilevc, animated: true)
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
}
