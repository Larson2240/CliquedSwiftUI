//
//  SignInDataSource.swift
//  Cliqued
//
//  Created by C211 on 11/01/23.
//


import UIKit
import AuthenticationServices

class SignInDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewController: SignInVC
    private let tableView: UITableView
    private let viewModel: SignInViewModel
    
    enum enumSignInTableRow: Int, CaseIterable {
        case appIcon = 0
        case email
        case password
        case rememberMe
        case button
        case socialLogin
        case termsText
    }
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: SignInViewModel, viewController: SignInVC) {
        self.viewController = viewController
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        setupTableView()
    }
    
    //MARK: - Class methods
    func setupTableView(){
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        registerTableCell()
    }
    
    func registerTableCell(){
        tableView.registerNib(nibNames: [LogoCell.identifier, TextFieldCell.identifier,ButtonCell.identifier, ForgotAndRemembarPasswordCell.identifier, SocialLoginOptionCell.identifier, TermsConditionTextCell.identifier])
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enumSignInTableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumSignInTableRow(rawValue: indexPath.row)! {
        case .appIcon:
            let cell = tableView.dequeueReusableCell(withIdentifier: LogoCell.identifier) as! LogoCell
            cell.selectionStyle = .none
            return cell
        case.email:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier) as! TextFieldCell
            cell.selectionStyle = .none
            cell.imageviewLeftSideIcon.image = UIImage(named: "ic_email")
            cell.buttonRightSideIcon.isHidden = true
            cell.labelTextFieldTitle.text = Constants.label_email
            cell.textfiled.keyboardType = .emailAddress
            cell.textfiled.placeholder = Constants.placeholder_email
            cell.textfiled.tag = enumSignInTableRow.email.rawValue
            cell.textfiled.text = viewModel.getEmail()
            cell.textfiled.delegate = self
            return cell
        case .password:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier) as! TextFieldCell
            cell.selectionStyle = .none
            cell.imageviewLeftSideIcon.image = UIImage(named: "ic_password")
            cell.buttonRightSideIcon.isHidden = false
            cell.labelTextFieldTitle.text = Constants.label_password
            cell.textfiled.placeholder = Constants.placeholder_password
            cell.textfiled.isSecureTextEntry = true
            cell.textfiled.tag = enumSignInTableRow.password.rawValue
            cell.textfiled.text = viewModel.getPassword()
            cell.textfiled.delegate = self
            cell.buttonRightSideIcon.isHidden = false
            cell.buttonRightSideIcon.tag = indexPath.row
            cell.buttonRightSideIcon.addTarget(self, action: #selector(buttonPasswordTap(_:)), for: .touchUpInside)
            return cell
        case .rememberMe:
            let cell = tableView.dequeueReusableCell(withIdentifier: ForgotAndRemembarPasswordCell.identifier) as! ForgotAndRemembarPasswordCell
            cell.buttonRemembarMe.tag = enumSignInTableRow.rememberMe.rawValue
            cell.buttonForgotPassword.tag = enumSignInTableRow.rememberMe.rawValue
            cell.buttonRemembarMe.addTarget(self, action: #selector(buttonRememberMeTap(_:)), for: .touchUpInside)
            cell.buttonForgotPassword.addTarget(self, action: #selector(buttonForgotPwdTap(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier) as! ButtonCell
            cell.button.tag = enumSignInTableRow.button.rawValue
            cell.button.setTitle(Constants.btn_logIn, for: .normal)
            cell.button.addTarget(self, action: #selector(buttonSignInTap(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        case .socialLogin:
            let cell = tableView.dequeueReusableCell(withIdentifier: SocialLoginOptionCell.identifier) as! SocialLoginOptionCell
            cell.selectionStyle = .none
            
            cell.buttonGoogle.addTarget(self, action: #selector(btnGoogleLoginTap(_:)), for: .touchUpInside)
            cell.buttonApple.addTarget(self, action: #selector(btnAppleLogin(_:)), for: .touchUpInside)
            
            let attrs : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : CustomFont.THEME_FONT_Bold(17) ?? "",
                NSAttributedString.Key.foregroundColor : Constants.color_DarkGrey
            ]
            let orgText = Constants.btn_dontHaveAccount
            let attriOrgText = NSMutableAttributedString(string: orgText)
            let linkText = attriOrgText.mutableString.range(of: Constants.btn_signUp)
            attriOrgText.addAttributes(attrs, range: linkText)
            cell.buttonDontHaveAccount.titleLabel?.adjustsFontSizeToFitWidth = true
            cell.buttonDontHaveAccount.titleLabel?.minimumScaleFactor = 0.5
            cell.buttonDontHaveAccount.titleLabel?.font = CustomFont.THEME_FONT_Regular(16)
            cell.buttonDontHaveAccount.setTitleColor(Constants.color_DarkGrey, for: .normal)
            cell.buttonDontHaveAccount.setAttributedTitle(attriOrgText, for: .normal)
            cell.buttonDontHaveAccount.addTarget(self, action: #selector(buttonHaveAccountTap(_:)), for: .touchUpInside)
            return cell
        case .termsText:
            let cell = tableView.dequeueReusableCell(withIdentifier: TermsConditionTextCell.identifier) as! TermsConditionTextCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    //MARK: Button Action remember me
    @objc func buttonRememberMeTap(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! ForgotAndRemembarPasswordCell
        if !viewModel.getRememberMe() {
            cell.buttonRemembarMe.setImage(UIImage(named: "ic_rememberme_selected"), for: .normal)
            viewModel.setRememberMe(value: true)
            userDefaults.set(true, forKey: UserDefaultKey.isRemeberMe)
        } else {
            cell.buttonRemembarMe.setImage(UIImage(named: "ic_rememberme_unselect"), for: .normal)
            viewModel.setRememberMe(value: false)
            userDefaults.set(false, forKey: UserDefaultKey.isRemeberMe)
        }
    }
    
    //MARK: Button hide show password
    @objc func buttonPasswordTap(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TextFieldCell
        if cell.textfiled.isSecureTextEntry == true {
            cell.textfiled.isSecureTextEntry = false
            cell.buttonRightSideIcon.setImage(UIImage(named: "ic_eye_show"), for: .normal)
        } else {
            cell.textfiled.isSecureTextEntry = true
            cell.buttonRightSideIcon.setImage(UIImage(named: "ic_eye_hide"), for: .normal)
        }
    }
    //MARK: Button Forgot Password Tap
    @objc func buttonForgotPwdTap(_ sender: UIButton) {
        let forgotpwdvc = ForgotPasswordVC.loadFromNib()
        viewController.navigationController?.pushViewController(forgotpwdvc, animated: true)
    }
    //MARK: Button DontAccount UI & Click Action
    @objc func buttonHaveAccountTap(_ sender: UIButton) {
        if viewController.isFromSignUpScreen {
            viewController.navigationController?.popViewController(animated: true)
        } else {
            let signupvc = SignUpVC.loadFromNib()
            signupvc.isFromSignInScreen = true
            viewController.navigationController?.pushViewController(signupvc, animated: true)
        }
    }
    //MARK: Button Login Tap
    @objc func buttonSignInTap(_ sender: UIButton) {
        viewController.view.endEditing(true)
        if viewModel.getWrongPasswordCount() >= 3 {
            viewModel.setResetWrongPasswordCount()
            viewController.showAlerBox("", Constants.validMsg_wrongPasswordAttempt) { _ in
                let forgotpwdvc = ForgotPasswordVC.loadFromNib()
                forgotpwdvc.isResetPassword = true
                forgotpwdvc.emailId = self.viewModel.getEmail()
                self.viewController.navigationController?.pushViewController(forgotpwdvc, animated: true)
            }
        } else {
            viewModel.callSignInAPI()
        }
    }
    
    //MARK: Button Google Login Tap
    @objc func btnGoogleLoginTap(_ sender: UIButton) {
        viewController.handleGoogleSignIn()
    }
    //MARK: Button Apple Login Tap
    @objc func btnAppleLogin(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = viewController
            authorizationController.performRequests()
        } else {
            viewController.showAlertPopup(message: Constants.warningIOSVersion)
        }
    }
}

//MARK: TextField Delegate
extension SignInDataSource: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch enumSignInTableRow(rawValue: textField.tag) {
        case .email:
            viewModel.setEmail(value: textField.text ?? "")
        case .password:
            viewModel.setPassword(value: textField.text ?? "")
        default:
            break
        }
    }
}
