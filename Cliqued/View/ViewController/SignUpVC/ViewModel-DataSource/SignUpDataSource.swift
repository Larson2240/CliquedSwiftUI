//
//  SignUpDataSource.swift
//  Cliqued
//
//  Created by C211 on 12/01/23.
//


import UIKit
import SwiftMessages
import AuthenticationServices

class SignUpDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewController: SignUpVC
    private let tableView: UITableView
    private let viewModel: SignUpViewModel
    
    enum enumSignUpTableRow: Int, CaseIterable {
        case appIcon = 0
        case email
        case password
        case repeatPassword
        case button
        case socialLogin
        case termsText
    }
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: SignUpViewModel, viewController: SignUpVC) {
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
        return enumSignUpTableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumSignUpTableRow(rawValue: indexPath.row)! {
        case .appIcon:
            let cell = tableView.dequeueReusableCell(withIdentifier: LogoCell.identifier) as! LogoCell
            cell.selectionStyle = .none
            return cell
        case.email:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier) as! TextFieldCell
            cell.selectionStyle = .none
            cell.imageviewLeftSideIcon.image = UIImage(named: "ic_email")
            cell.buttonRightSideIcon.isHidden = true
            cell.textfiled.keyboardType = .emailAddress
            cell.labelTextFieldTitle.text = Constants.label_email
            cell.textfiled.placeholder = Constants.placeholder_email
            cell.textfiled.tag = enumSignUpTableRow.email.rawValue
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
            cell.textfiled.tag = enumSignUpTableRow.password.rawValue
            cell.textfiled.text = viewModel.getPassword()
            cell.textfiled.delegate = self
            cell.buttonRightSideIcon.isHidden = false
            cell.buttonRightSideIcon.tag = indexPath.row
            cell.buttonRightSideIcon.addTarget(self, action: #selector(buttonPasswordTap(_:)), for: .touchUpInside)
            return cell
        case .repeatPassword:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier) as! TextFieldCell
            cell.selectionStyle = .none
            cell.imageviewLeftSideIcon.image = UIImage(named: "ic_password")
            cell.buttonRightSideIcon.isHidden = false
            cell.labelTextFieldTitle.text = Constants.label_repeatPassword
            cell.textfiled.placeholder = Constants.placeholder_repeatPassword
            cell.textfiled.isSecureTextEntry = true
            cell.textfiled.tag = enumSignUpTableRow.repeatPassword.rawValue
            cell.textfiled.text = viewModel.getConfirmPassword()
            cell.textfiled.delegate = self
            cell.buttonRightSideIcon.isHidden = false
            cell.buttonRightSideIcon.tag = indexPath.row
            cell.buttonRightSideIcon.addTarget(self, action: #selector(buttonPasswordTap(_:)), for: .touchUpInside)
            return cell
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier) as! ButtonCell
            cell.button.setTitle(Constants.btn_signUp, for: .normal)
            cell.button.tag = enumSignUpTableRow.button.rawValue
            cell.button.addTarget(self, action: #selector(btnSignUpTap(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        case .socialLogin:
            let cell = tableView.dequeueReusableCell(withIdentifier: SocialLoginOptionCell.identifier) as! SocialLoginOptionCell
            
            cell.buttonGoogle.addTarget(self, action: #selector(btnGoogleLoginTap(_:)), for: .touchUpInside)
            cell.buttonApple.addTarget(self, action: #selector(btnAppleLogin(_:)), for: .touchUpInside)
            
            let attrs : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : CustomFont.THEME_FONT_Bold(17) ?? "",
                NSAttributedString.Key.foregroundColor : Constants.color_DarkGrey
            ]
            let orgText = Constants.btn_alreadyHaveAccount
            let attriOrgText = NSMutableAttributedString(string: orgText)
            let linkText = attriOrgText.mutableString.range(of: Constants.btn_logIn)
            attriOrgText.addAttributes(attrs, range: linkText)
            cell.buttonDontHaveAccount.titleLabel?.font = CustomFont.THEME_FONT_Regular(16)
            cell.buttonDontHaveAccount.setTitleColor(Constants.color_DarkGrey, for: .normal)
            cell.buttonDontHaveAccount.setAttributedTitle(attriOrgText, for: .normal)
            cell.buttonDontHaveAccount.addTarget(self, action: #selector(buttonHaveAccountTap(_:)), for: .touchUpInside)
            cell.buttonDontHaveAccount.addTarget(self, action: #selector(buttonHaveAccountTap(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        case .termsText:
            let cell = tableView.dequeueReusableCell(withIdentifier: TermsConditionTextCell.identifier) as! TermsConditionTextCell
            cell.selectionStyle = .none
            return cell
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
    //MARK: Button DontAccount UI & Click Action
    @objc func buttonHaveAccountTap(_ sender: UIButton) {
        if viewController.isFromSignInScreen {
            viewController.navigationController?.popViewController(animated: true)
        } else {
            let signupvc = SignInVC.loadFromNib()
            signupvc.isFromSignUpScreen = true
            viewController.navigationController?.pushViewController(signupvc, animated: true)
        }
    }
    //MARK: Button SignUp Tap
    @objc func btnSignUpTap(_ sender: UIButton) {
        viewController.view.endEditing(true)
        viewModel.callSignUpAPI()
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
extension SignUpDataSource: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch enumSignUpTableRow(rawValue: textField.tag) {
        case .email:
            viewModel.setEmail(value: textField.text ?? "")
        case .password:
            viewModel.setPassword(value: textField.text ?? "")
        case .repeatPassword:
            viewModel.setConfirmPassword(value: textField.text ?? "")
        default:
            break
        }
    }
}
