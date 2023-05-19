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
            labelMainTitle.text = Constants.label_ageScreenTitle
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
    @IBOutlet weak var buttonContinue: UIButton!{
        didSet{
            setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
        }
    }
    //MARK: Variable
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK: Button Continue Click Event
    @IBAction func btnContinueTap(_ sender: Any) {
        let gendervc = GenderVC.loadFromNib()
        self.navigationController?.pushViewController(gendervc, animated: true)
    }
}
//MARK: Extension UDF
extension AgeVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupDatePicker()
        setupProgressView()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_age
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
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
        if #available(iOS 13.4, *) {
            datepicker?.preferredDatePickerStyle = .wheels
        }
    }
}
