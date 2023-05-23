//
//  NameVC.swift
//  Cliqued
//
//  Created by C211 on 13/01/23.
//

import UIKit
import IQKeyboardManager

class NameVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_nameScreenTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelSubTitle: UILabel!{
        didSet {
            labelSubTitle.text = Constants.label_nameScreenSubTitle
            labelSubTitle.font = CustomFont.THEME_FONT_Book(14)
            labelSubTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelTextFieldTitle: UILabel!{
        didSet {
            labelTextFieldTitle.text = Constants.label_name
            labelTextFieldTitle.font = CustomFont.THEME_FONT_Bold(18)
            labelTextFieldTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var textfiledName: UITextField!{
        didSet {
            textfiledName.font = CustomFont.THEME_FONT_Bold(18)
            textfiledName.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonContinue: UIButton!
    
    //MARK: Variable
    var selectedDate: String?
    lazy var viewModel = SignUpProcessViewModel()
    private let profileSetupType = ProfileSetupType()
    private let loginTypeModel = LoginType()
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    //MARK: viewWillDisappear Method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
    }
    
    //MARK: Button Countinue Tap
    @IBAction func btnContinueTap(_ sender: Any) {
        view.endEditing(true)
        viewModel.setProfileSetupType(value: profileSetupType.name)
        if viewModel.getName().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlertPopup(message: Constants.validMsg_name)
        } else {
            let isValidName = isOnlyCharacter(text: viewModel.getName())
            if isValidName {
                viewModel.callSignUpProcessAPI()
            } else {
                showAlertPopup(message: Constants.validMsg_validName)
            }
        }
    }
}
//MARK: Extension UDF
extension NameVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupTextfiledPlaceholder()
        setupProgressView()
        
        //Check for social login
        if let loginType = Constants.loggedInUser?.connectedAccount?[0].loginType {
            if loginType == loginTypeModel.APPLE || loginType == loginTypeModel.FACEBOOK || loginType == loginTypeModel.GOOGLE {
                prefilledNameForSocialLoginUser()
            }
        }
        textfiledName.delegate = self
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_name
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonSkip.addTarget(self, action: #selector(buttonSkipTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = true
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = false
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
        let currentProgress = 1
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
    //MARK: Prefilled name for social login
    func prefilledNameForSocialLoginUser() {
        let userName = UserDefaults.standard.string(forKey: UserDefaultKey().userName)
        viewModel.setName(value: userName ?? "")
        if userName != "" {
            self.textfiledName.text = userName
        }
    }
    //MARK: Setup TextFiled Placeholder
    func setupTextfiledPlaceholder() {
        textfiledName.attributedPlaceholder = NSAttributedString(
            string: Constants.placeholder_name,
            attributes: [NSAttributedString.Key.font: CustomFont.THEME_FONT_Regular(16)!]
        )
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
                let agevc = AgeVC.loadFromNib()
                agevc.name = self.viewModel.getName()
                self.navigationController?.pushViewController(agevc, animated: true)
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
//MARK: TextField Delegate
extension NameVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.setName(value: textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
