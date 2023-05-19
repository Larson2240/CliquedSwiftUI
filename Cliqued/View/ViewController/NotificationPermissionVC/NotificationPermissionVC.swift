//
//  NotificationPermissionVC.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit

class NotificationPermissionVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_notificationScreenSubTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonEnableNotification: UIButton!
    @IBOutlet weak var buttonDisableNotification: UIButton!
    @IBOutlet weak var buttonSaveProfile: UIButton!{
        didSet{
            setupButtonUI(buttonName: buttonSaveProfile, buttonTitle: Constants.btn_saveProfile)
        }
    }
    
    //MARK: Variable
    var isEnableNotification: Bool = false
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Button Continue Click Event
    @IBAction func btnSaveProfileTap(_ sender: Any) {
        let startExploringVC = StartExploringVC.loadFromNib()
        self.navigationController?.pushViewController(startExploringVC, animated: true)
    }
    
    //MARK: Button Enable Notification Click
    @IBAction func btnEnableNotificationTap(_ sender: Any) {
        isEnableNotification = true
        setupNotificationButtonUI()
    }
    
    //MARK: Button Disable Notification Click
    @IBAction func btnDisableNotificationTap(_ sender: Any) {
        isEnableNotification = false
        setupNotificationButtonUI()
    }
}
//MARK: Extension UDF
extension NotificationPermissionVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupNotificationButtonUI()
        setupProgressView()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_notification
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Setup ProgressView progress
    func setupProgressView() {
        let currentProgress = 9
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
    func setupNotificationButtonUI() {
        if isEnableNotification {
            selectedButtonUI(buttonName: buttonEnableNotification, buttonTitle: Constants.btn_enableNotification)
            unselectedButtonUI(buttonName: buttonDisableNotification, buttonTitle: Constants.btn_disableNotification)
        } else {
            selectedButtonUI(buttonName: buttonDisableNotification, buttonTitle: Constants.btn_disableNotification)
            unselectedButtonUI(buttonName: buttonEnableNotification, buttonTitle: Constants.btn_enableNotification)
        }
    }
    func selectedButtonUI(buttonName: UIButton, buttonTitle: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
        buttonName.setTitleColor(Constants.color_white, for: .normal)
        buttonName.backgroundColor = Constants.color_GreenSelectedBkg
        buttonName.layer.cornerRadius = 8.0
    }
    func unselectedButtonUI(buttonName: UIButton, buttonTitle: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
        buttonName.setTitleColor(Constants.color_DarkGrey, for: .normal)
        buttonName.backgroundColor = Constants.color_GreyUnselectedBkg
        buttonName.layer.cornerRadius = 8.0
    }
}
