//
//  SettingsVC.swift
//  Cliqued
//
//  Created by C211 on 23/01/23.
//

import UIKit

class SettingsVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet var buttonDeleteAccount: UIButton!
    
    //MARK: Variable
    var dataSource : SettingsDataSource?
    lazy var viewModel = SettingsViewModel()
    var user_id = "\(Constants.loggedInUser?.id ?? 0)"
    var is_englishSelected = true
    var selectedLanguage = ""
        
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setIsOnline(value: "\(Constants.loggedInUser?.isOnline ?? "1")")
        viewModel.setIsLastSeen(value: "\(Constants.loggedInUser?.isUserLastSeenEnable ?? "1")")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonLogout, buttonTitle: Constants.btn_logout)
        setupButtonUIWithOutBackground(buttonName: buttonDeleteAccount, buttonTitle:Constants_Message.title_delete_account)
    }
    
    //MARK: Button Logout Click
    @IBAction func btnLogoutClick(_ sender: Any) {
        self.alertCustom(btnNo:Constants.btn_cancel, btnYes:Constants.btn_logout, title: "", message: Constants.label_logoutAlertMsg) { [weak self] in
            self?.viewModel.callLogoutAPI()
        }
    }
    
    @IBAction func buttonDeleteAccount(_ sender: UIButton) {
        self.alertCustom(btnNo:Constants.btn_cancel, btnYes:Constants_Message.btn_delete, title: "", message: Constants.label_deleteAlertMsg) { [weak self] in
            self?.viewModel.callDeleteAccountAPI()
        }
    }
}
//MARK: Extension UDF
extension SettingsVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = SettingsDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        
        viewModel.setUserId(value: "\(user_id)")
        viewModel.setProfileSetupType(value: "\(Constants.loggedInUser?.profileSetupType ?? "10")")
        
        
        if let strLanguage = UserDefaults.standard.string(forKey: USER_DEFAULT_KEYS.kUserLanguage) {
            selectedLanguage = strLanguage
        } else {
            selectedLanguage = Language1.en.rawValue
        }
     
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_settings
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { isSuccess in
            if isSuccess {
            }
        }
        
        viewModel.isLogout.bind { isSuccess in
            if isSuccess {
                UserDefaults.standard.clearUserDefault()
                APP_DELEGATE.setRegisterOptionRootViewController()
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
