//
//  GenderVC.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class GenderVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
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
    @IBOutlet weak var buttonContinue: UIButton!{
        didSet{
            setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
        }
    }
    
    @IBOutlet weak var buttonFemale: UIButton!
    @IBOutlet weak var buttonMale: UIButton!
    
    
    //MARK: Variable
    var isMaleSelected: Bool = false
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func btnFemaleTap(_ sender: Any) {
        isMaleSelected = false
        setupGenderButtonUI()
    }
    
    @IBAction func btnMaleTap(_ sender: Any) {
        isMaleSelected = true
        setupGenderButtonUI()
    }
    
    //MARK: Button Continue Click Event
    @IBAction func btnContinueTap(_ sender: Any) {
        let relationshipvc = RelationshipVC.loadFromNib()
        self.navigationController?.pushViewController(relationshipvc, animated: true)
    }
}
//MARK: Extension UDF
extension GenderVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupGenderButtonUI()
        setupProgressView()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_gender
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
        let currentProgress = 3
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
    
    func setupGenderButtonUI() {
        if isMaleSelected {
            selectedButtonUI(buttonName: buttonMale, buttonTitle: Constants.btn_male)
            unselectedButtonUI(buttonName: buttonFemale, buttonTitle: Constants.btn_female)
        } else {
            selectedButtonUI(buttonName: buttonFemale, buttonTitle: Constants.btn_female)
            unselectedButtonUI(buttonName: buttonMale, buttonTitle: Constants.btn_male)
        }
    }
    
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
}
