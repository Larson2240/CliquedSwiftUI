//
//  GenderVC.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class GenderVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_genderScreenTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelSubTitle: UILabel!{
        didSet {
            labelSubTitle.text = Constants.label_genderScreenSubTitle
            labelSubTitle.font = CustomFont.THEME_FONT_Book(14)
            labelSubTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var buttonFemale: UIButton!
    @IBOutlet weak var buttonMale: UIButton!
    
    //MARK: Variable
    var isMaleSelected: Bool = false
    var isAnyoneSelected: Bool = false
    lazy var viewModel = SignUpProcessViewModel()
    private let profileSetupType = ProfileSetupType()
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
    }

    @IBAction func btnFemaleTap(_ sender: Any) {
        isAnyoneSelected = true
        isMaleSelected = false
        setupGenderButtonUI()
        viewModel.setGender(value: "2")
    }
    
    @IBAction func btnMaleTap(_ sender: Any) {
        isAnyoneSelected = true
        isMaleSelected = true
        setupGenderButtonUI()
        viewModel.setGender(value: "1")
    }
    
    //MARK: Button Continue Click Event
    @IBAction func btnContinueTap(_ sender: Any) {
        if isAnyoneSelected {
            viewModel.setProfileSetupType(value: profileSetupType.gender)
            viewModel.callSignUpProcessAPI()
        } else {
            showAlertPopup(message: Constants.validMsg_gender)
        }
    }
}
//MARK: Extension UDF
extension GenderVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupGenderButtonUI()
        setupProgressView()
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_gender
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
        let currentProgress = 3
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
    //MARK: Setup Gender Button UI
    func setupGenderButtonUI() {
        if isAnyoneSelected {
            if isMaleSelected {
                selectedButtonUI(buttonName: buttonMale, buttonTitle: Constants.btn_male)
                unselectedButtonUI(buttonName: buttonFemale, buttonTitle: Constants.btn_female)
            } else {
                selectedButtonUI(buttonName: buttonFemale, buttonTitle: Constants.btn_female)
                unselectedButtonUI(buttonName: buttonMale, buttonTitle: Constants.btn_male)
            }
        } else {
            disableButtonUI(buttonName: buttonFemale, buttonTitle: Constants.btn_female, iconName: "ic_female_black")
            disableButtonUI(buttonName: buttonMale, buttonTitle: Constants.btn_male, iconName: "ic_male_black")
        }
    }
    //MARK: UI Of Selected Button
    func selectedButtonUI(buttonName: UIButton, buttonTitle: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
        buttonName.setTitleColor(Constants.color_white, for: .normal)
        buttonName.backgroundColor = Constants.color_GreenSelectedBkg
        buttonName.layer.cornerRadius = 8.0
        if isMaleSelected {
            buttonName.setImage(UIImage(named: "ic_male_white"), for: .normal)
        } else {
            buttonName.setImage(UIImage(named: "ic_female_white"), for: .normal)
        }
    }
    //MARK: UI Of Un-selected Button
    func unselectedButtonUI(buttonName: UIButton, buttonTitle: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
        buttonName.setTitleColor(Constants.color_DarkGrey, for: .normal)
        buttonName.backgroundColor = Constants.color_GreyUnselectedBkg
        buttonName.layer.cornerRadius = 8.0
        if isMaleSelected {
            buttonName.setImage(UIImage(named: "ic_female_black"), for: .normal)
        } else {
            buttonName.setImage(UIImage(named: "ic_male_black"), for: .normal)
        }
    }
    
    //MARK: UI Of disable button
    func disableButtonUI(buttonName: UIButton, buttonTitle: String, iconName: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
        buttonName.setTitleColor(Constants.color_DarkGrey, for: .normal)
        buttonName.backgroundColor = Constants.color_GreyUnselectedBkg
        buttonName.layer.cornerRadius = 8.0
        buttonName.setImage(UIImage(named: iconName), for: .normal)
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
                let relationshipvc = RelationshipVC.loadFromNib()
                self.navigationController?.pushViewController(relationshipvc, animated: true)
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
