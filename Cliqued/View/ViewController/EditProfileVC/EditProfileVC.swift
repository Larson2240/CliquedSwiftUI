//
//  EditProfileVC.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit

class EditProfileVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var buttonSave: UIButton!
    
    //MARK: Variable
    var dataSource : EditProfileDataSource?
    lazy var viewModel = EditProfileViewModel()
    var objUserDetails: User?
    var callbackForUpdateProfile: ((_ isUpdate: Bool) -> Void)?
    var isUpdateData: Bool = false
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonSave, buttonTitle: Constants.btn_save)
    }
    
    //MARK: Button Submit Click
    @IBAction func btnSaveClick(_ sender: Any) {
        self.view.endEditing(true)
        viewModel.setProfileSetupType(value: ProfileSetupType.completed)
        let isValidName = isOnlyCharacter(text: viewModel.getName())
        if isValidName {
            viewModel.callSignUpProcessAPI()
        } else {
            self.showAlertPopup(message: Constants.validMsg_validName)
        }
    }
}
//MARK: Extension UDF
extension EditProfileVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = EditProfileDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        viewModel.bindUserDetailsData()
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_editProfile
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        if isUpdateData {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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
                self.callbackForUpdateProfile?(true)
                self.navigationController?.popToRootViewController(animated: true)
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
