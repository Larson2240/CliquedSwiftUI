//
//  AgeVC.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class AgeVC: UIViewController {
    
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelSubTitle: UILabel!{
        didSet {
            labelSubTitle.text = Constants.label_ageScreenSubTitle
            labelSubTitle.font = CustomFont.THEME_FONT_Book(14)
            labelSubTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var datepickerView: UIView!{
        didSet {
            datepickerView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var datepicker: UIDatePicker!{
        didSet {
            datepicker.layer.cornerRadius = 10.0
            datepicker.backgroundColor = .clear
        }
    }
    @IBOutlet weak var buttonContinue: UIButton!
    
    //MARK: Variable
    lazy var viewModel = SignUpProcessViewModel()
    var name: String?
    var selectedDate: String?
    // Age of 45.
    let MINIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -45, to: Date())!;
    // Age of 150.
    let MAXIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -150, to: Date())!;
    
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
    
    //MARK: Button Continue Click Event
    @IBAction func btnContinueTap(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormatter.string(from: datepicker.date)
        let isValidAge = validateAge(birthDate: datepicker.date)
        self.viewModel.setDateOfBirth(value: selectedDate ?? "")
        if(isValidAge) {
            showAlertPopup(message: Constants.validMsg_age)
        } else {
            viewModel.setProfileSetupType(value: ProfileSetupType.birthdate)
            self.viewModel.callSignUpProcessAPI()
        }
    }
}
//MARK: Extension UDF
extension AgeVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupDatePicker()
        setupProgressView()
        labelMainTitle.text = "\(Constants.label_ageScreenTitleBeforName) \(name ?? "") \(Constants.label_ageScreenTitleAfterName)"
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_age
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
        let currentProgress = 2
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
    //MARK: Setup Date Picker
    func setupDatePicker() {
        datepicker?.date = Date()
        datepicker?.locale = .current
        datepicker?.datePickerMode = .date
        datepicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datepicker?.preferredDatePickerStyle = .wheels
        }
    }
    //MARK: Age Validation
    func validateAge(birthDate: Date) -> Bool {
        var isValid: Bool = true;
        if birthDate >= MAXIMUM_AGE && birthDate <= MINIMUM_AGE {
            isValid = false;
        }
        return isValid;
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
                let gendervc = GenderVC.loadFromNib()
                self.navigationController?.pushViewController(gendervc, animated: true)
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
