//
//  UpdateEmailVC.swift
//  Cliqued
//
//  Created by C100-132 on 16/02/23.
//

import UIKit

class UpdateEmailVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet var textField: UITextField! {
        didSet {
            textField.font = CustomFont.THEME_FONT_Medium(16)
            textField.textColor = Constants.color_DarkGrey
            textField.placeholder = Constants.placeholder_email
        }
    }
    @IBOutlet var labelTitle: UILabel! {
        didSet {
            labelTitle.font = CustomFont.THEME_FONT_Medium(14)
            labelTitle.textColor = Constants.color_DarkGrey
            labelTitle.text = Constants.label_email
        }
    }
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet var buttonSubmit: UIButton!
    
    //MARK: - Varialbes
    var viewModel = UpdateEmailViewModel()
    
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
        setupButtonUI(buttonName: buttonSubmit, buttonTitle: Constants.btn_changeEmail)
    }
    
    //MARK: - TextField Action
    @IBAction func textFieldAction(_ sender: UITextField) {
        viewModel.setNewEmailId(value: (textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!)
    }
    
    //MARK: - Button Action
    @IBAction func buttonSubmitAction(_ sender: UIButton) {
        view.endEditing(true)
        
        alertWithTextField(title: "", message: Constants.label_newEmailTitle, placeholder: Constants.placeholder_email) { [weak self] result in
            guard let self = self else { return }
            
            self.viewModel.setNewEmailId(value: (result.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)))
            self.viewModel.callSendOTPAPI()
        }
    }
}

//MARK: Extension UDF
extension UpdateEmailVC {
        
    func viewDidLoadMethod() {
        setupNavigationBar()
        
        viewModel.setUserId(value: "\(Constants.loggedInUser?.id ?? 0)")
        viewModel.setEmailId(value: "\(Constants.loggedInUser?.connectedAccount![0].emailId ?? "")")
        
        textField.text = viewModel.getEmailId()
        
        handleApiResponse()
    }
    
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants_Message.title_email_settings
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
            guard let self = self else { return }
            
            if isSuccess {
                let vc = EmailVerificationVC.loadFromNib()
                vc.newEmailId = self.viewModel.getNewEmailId()
                self.navigationController?.pushViewController(vc, animated: true)
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
    
    public func alertWithTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: Constants.btn_cancel, style: .cancel,handler:nil))
        alert.addAction(UIAlertAction(title: Constants.btn_submit, style: .default) { action in
            if
                let textFields = alert.textFields,
                let tf = textFields.first,
                let result = tf.text
            { completion(result) }
            else
            { completion("") }
        })
        navigationController?.present(alert, animated: true)
    }
}
