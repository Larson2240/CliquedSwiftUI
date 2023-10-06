//
//  ChangePasswordVC.swift
//  Cliqued
//
//  Created by C100-132 on 17/02/23.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet var textFieldOldPassword: UITextField! {
        didSet {
            textFieldOldPassword.font = CustomFont.THEME_FONT_Medium(16)
            textFieldOldPassword.textColor = Constants.color_DarkGrey
            textFieldOldPassword.placeholder = Constants_Message.placeholder_Old_password
        }
    }
    @IBOutlet var labelTitleOldPassword: UILabel! {
        didSet {
            labelTitleOldPassword.font = CustomFont.THEME_FONT_Medium(14)
            labelTitleOldPassword.textColor = Constants.color_DarkGrey
            labelTitleOldPassword.text = Constants_Message.label_Old_password
        }
    }
    
    @IBOutlet var textFieldPassword: UITextField! {
        didSet {
            textFieldPassword.font = CustomFont.THEME_FONT_Medium(16)
            textFieldPassword.textColor = Constants.color_DarkGrey
            textFieldPassword.placeholder = Constants_Message.placeholder_New_password
        }
    }
    @IBOutlet var labelTitlePassword: UILabel! {
        didSet {
            labelTitlePassword.font = CustomFont.THEME_FONT_Medium(14)
            labelTitlePassword.textColor = Constants.color_DarkGrey
            labelTitlePassword.text = Constants_Message.label_new_password
        }
    }
    @IBOutlet var textFieldNewPassword: UITextField! {
        didSet {
            textFieldNewPassword.font = CustomFont.THEME_FONT_Medium(16)
            textFieldNewPassword.textColor = Constants.color_DarkGrey
            textFieldNewPassword.placeholder = Constants.placeholder_repeatPassword
        }
    }
    @IBOutlet var labelTitleNewPassword: UILabel! {
        didSet {
            labelTitleNewPassword.font = CustomFont.THEME_FONT_Medium(14)
            labelTitleNewPassword.textColor = Constants.color_DarkGrey
            labelTitleNewPassword.text = Constants.label_repeatPassword
        }
    }
    
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet var buttonChangePassword: UIButton!
    @IBOutlet var buttonOldPasswordShow: UIButton!
    @IBOutlet var buttonNewPasswordShow: UIButton!
    @IBOutlet var buttonConfirmPasswordShow: UIButton!

    //MARK: - Varialbes
    var viewModel = ChangePasswordViewModel()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonChangePassword, buttonTitle: Constants.btn_changePassword)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    //MARK: - TextField Action
    @IBAction func textFieldAction(_ sender: UITextField) {
        
        switch sender.tag {
        case 1:
            viewModel.setOldPassword(value: (textFieldOldPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!)
            break
            
        case 2:
            viewModel.setNewPassword(value: (textFieldPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!)
            break
            
        case 3:
            viewModel.setConfirmPassword(value: (textFieldNewPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!)
            break
            
        default:
            break
        }
    }
    
    //MARK: - Button Action
    @IBAction func buttonChangePasswordAction(_ sender: UIButton) {
        view.endEditing(true)
        viewModel.callChangePasswordAPI()
    }
    
    
    @IBAction func buttonShowPasswordAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if textFieldOldPassword.isSecureTextEntry == true {
                textFieldOldPassword.isSecureTextEntry = false
                buttonOldPasswordShow.setImage(UIImage(named: "ic_eye_show"), for: .normal)
            } else {
                textFieldOldPassword.isSecureTextEntry = true
                buttonOldPasswordShow.setImage(UIImage(named: "ic_eye_hide"), for: .normal)
            }
            break
            
        case 2:
            if textFieldPassword.isSecureTextEntry == true {
                textFieldPassword.isSecureTextEntry = false
                buttonNewPasswordShow.setImage(UIImage(named: "ic_eye_show"), for: .normal)
            } else {
                textFieldPassword.isSecureTextEntry = true
                buttonNewPasswordShow.setImage(UIImage(named: "ic_eye_hide"), for: .normal)
            }
            break
            
        case 3:
            if textFieldNewPassword.isSecureTextEntry == true {
                textFieldNewPassword.isSecureTextEntry = false
                buttonConfirmPasswordShow.setImage(UIImage(named: "ic_eye_show"), for: .normal)
            } else {
                textFieldNewPassword.isSecureTextEntry = true
                buttonConfirmPasswordShow.setImage(UIImage(named: "ic_eye_hide"), for: .normal)
            }
            break
            
        default:
            break
        }
    }
}

//MARK: Extension UDF
extension ChangePasswordVC {
        
    func viewDidLoadMethod() {
        setupNavigationBar()
//        viewModel.setUserId(value: "\(Constants.loggedInUser?.id ?? 0)")
        handleApiResponse()
    }
    
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_passwordSettings
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
        viewModel.isDataGet.bind { [weak self] isSuccess in
            if isSuccess {
                self?.navigationController?.popViewController(animated: true)
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
