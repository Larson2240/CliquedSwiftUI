//
//  EmailVerificationVC.swift
//  Cliqued
//
//  Created by C100-132 on 16/02/23.
//

import UIKit

class EmailVerificationVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet var labelTitle: UILabel! {
        didSet {
            labelTitle.font = CustomFont.THEME_FONT_Medium(14)
            labelTitle.textColor = Constants.color_DarkGrey
            labelTitle.text = Constants_Message.title_email_sub_text
        }
    }
    @IBOutlet var buttonVerifyNow: UIButton!
    @IBOutlet var buttonResendOTP: UIButton! {
        didSet {
            buttonResendOTP.setTitle(Constants_Message.btn_title_resend_otp, for: .normal)
            buttonResendOTP.titleLabel!.font = CustomFont.THEME_FONT_Medium(14)
            buttonResendOTP.titleLabel!.textColor = Constants.color_DarkGrey
            
        }
    }
    @IBOutlet var labelDidntGetCode: UILabel! {
        didSet {
            labelDidntGetCode.font = CustomFont.THEME_FONT_Medium(14)
            labelDidntGetCode.textColor = Constants.color_DarkGrey
            labelDidntGetCode.text = Constants_Message.title_didnot_receiver_otp
        }
    }
    @IBOutlet var otpView: OTPFieldView!
    
    //MARK: - Varialbes
    var viewModel = UpdateEmailViewModel()
    var code = ""
    var hasCodeFilled = false
    var newEmailId = ""
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpOTPView()
        setupButtonUI(buttonName: buttonVerifyNow, buttonTitle: Constants_Message.btn_verify)
    }
    
    //MARK: - Button Action
    @IBAction func buttonVerifyAction(_ sender: UIButton) {
        view.endEditing(true)
        viewModel.callVerifyOTPAndUpdateAPI()
    }
    
    @IBAction func buttonResendOTPAction(_ sender: Any) {
        view.endEditing(true)
        viewModel.callSendOTPAPI()
    }
}

//MARK: Extension UDF
extension EmailVerificationVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        
        
        viewModel.setNewEmailId(value: newEmailId)
        
        handleApiResponse()
    }
    
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants_Message.title_email_verification
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
    }
    
    //MARK: OTP UI Management
    func setUpOTPView() {
        let viewWidth = self.otpView.bounds.width
        let viewHeight = self.otpView.bounds.height
        let TFieldSize = viewHeight - 5
        let speacing = (viewWidth - (TFieldSize * 4)) / 4
        self.otpView.fieldsCount = 4
        self.otpView.fieldBorderWidth = 0.5
        self.otpView.defaultBorderColor = .darkGray
        self.otpView.filledBorderColor = Constants.color_themeColor
        self.otpView.cursorColor = Constants.color_themeColor
        self.otpView.fieldFont =  CustomFont.THEME_FONT_Medium(14)!
        self.otpView.displayType = .roundedCorner
        self.otpView.fieldSize = TFieldSize
        self.otpView.separatorSpace = speacing
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.defaultBackgroundColor = .clear
        self.otpView.filledBackgroundColor = Constants.color_themeColor
        self.otpView.delegate = self
        self.otpView.initializeUI()
        self.otpView.layoutIfNeeded()
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
        
        viewModel.isUserDataGet.bind { [weak self] isSuccess in
            if isSuccess {
                self?.navigationController?.popToRootViewController(animated: true)
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

//MARK: - UITEXTFIELD DELEGATE
extension EmailVerificationVC : OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
           hasCodeFilled = hasEntered
            if !hasEntered {
               self.code = ""
               viewModel.setOTPCode(value: self.code)
            }
           return false
       }
       
       func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
           return true
       }
       
       func enteredOTP(otp otpString: String) {          
           self.code = otpString
           viewModel.setOTPCode(value: self.code)
       }
}
