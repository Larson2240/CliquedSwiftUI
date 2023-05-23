//
//  ForgotPasswordVC.swift
//  Cliqued
//
//  Created by C211 on 10/02/23.
//

import UIKit
import IQKeyboardManager

class ForgotPasswordVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    
    @IBOutlet weak var labelDescription: UILabel!{
        didSet {
            labelDescription.text = Constants.label_ForgotPwdScreenDescription
            labelDescription.font = CustomFont.THEME_FONT_Medium(14)
            labelDescription.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelTextFieldTitle: UILabel!{
        didSet {
            labelTextFieldTitle.text = Constants.label_email
            labelTextFieldTitle.font = CustomFont.THEME_FONT_Medium(14)
            labelTextFieldTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var textfiled: UITextField!{
        didSet {
            textfiled.placeholder = Constants.placeholder_email
            textfiled.font = CustomFont.THEME_FONT_Medium(16)
            textfiled.textColor = Constants.color_DarkGrey
            textfiled.keyboardType = .emailAddress
            textfiled.setLeftPadding(30)
            textfiled.setRightPadding(30)
        }
    }
    @IBOutlet weak var buttonSend: UIButton!
    
    
    //MARK: Variable
    lazy var viewModel = ForgotPasswordViewModel()
    var emailId = ""
    var isResetPassword: Bool = false
    var isFirst : Bool = true
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonSend, buttonTitle: Constants.btn_send)
    }
    
    //MARK: Button send tap
    @IBAction func btnSendTap(_ sender: Any) {
        view.endEditing(true)
        viewModel.callForgotPasswordAPI()
    }
}
//MARK: Extension UDF
extension ForgotPasswordVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        autofillEmailId()
        textfiled.delegate = self
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_forgotPwd
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Autofill email id in textfiled
    func autofillEmailId() {
        if isResetPassword {
            textfiled.text = emailId
        } else {
            textfiled.text = ""
        }
    }
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { [weak self] message in
            guard let self = self else { return }
            
            self.showAlerBox("", message) { _ in
                self.navigationController?.popViewController(animated: true)
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
extension ForgotPasswordVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.setEmail(value: textfiled.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
