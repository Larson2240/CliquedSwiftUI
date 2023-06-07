//
//  RelationshipVC.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class RelationshipVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_relationshipScreenTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var labelSubTitle: UILabel!{
        didSet {
            labelSubTitle.text = Constants.label_relationshipScreenSubTitle
            labelSubTitle.font = CustomFont.THEME_FONT_Book(14)
            labelSubTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonContinue: UIButton!{
        didSet{
            setupButtonUI(buttonName: buttonContinue, buttonTitle: Constants.btn_continue)
        }
    }
    
    @IBOutlet weak var buttonRomance: UIButton!{
        didSet {
            buttonRomance.setTitle(Constants.btn_romance, for: .normal)
            buttonRomance.setImage(UIImage(named: "ic_romance_white"), for: .normal)
            buttonRomance.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonRomance.setTitleColor(Constants.color_white, for: .normal)
            buttonRomance.backgroundColor = Constants.color_GreenSelectedBkg
            buttonRomance.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var labelwith1: UILabel!{
        didSet {
            labelwith1.text = Constants.label_with
            labelwith1.font = CustomFont.THEME_FONT_Medium(15)
            labelwith1.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonRomanceWomen: UIButton!{
        didSet {
            buttonRomanceWomen.setTitle(Constants.btn_women, for: .normal)
            buttonRomanceWomen.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonRomanceWomen.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonRomanceWomen.backgroundColor = Constants.color_GreyUnselectedBkg
            buttonRomanceWomen.layer.cornerRadius = 8.0
        }
    }
    @IBOutlet weak var buttonRomanceMen: UIButton!{
        didSet {
            buttonRomanceMen.setTitle(Constants.btn_men, for: .normal)
            buttonRomanceMen.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonRomanceMen.setTitleColor(Constants.color_white, for: .normal)
            buttonRomanceMen.backgroundColor = Constants.color_GreenSelectedBkg
            buttonRomanceMen.layer.cornerRadius = 8.0
        }
    }
    
    @IBOutlet weak var buttonFriendship: UIButton!{
        didSet {
            buttonFriendship.setTitle(Constants.btn_friendship, for: .normal)
            buttonFriendship.setImage(UIImage(named: "ic_friendshipblack"), for: .normal)
            buttonFriendship.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonFriendship.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonFriendship.backgroundColor = Constants.color_GreyUnselectedBkg
            buttonFriendship.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var labelwith2: UILabel!{
        didSet {
            labelwith2.text = Constants.label_with
            labelwith2.font = CustomFont.THEME_FONT_Medium(15)
            labelwith2.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonFriendshipWomen: UIButton!{
        didSet {
            buttonFriendshipWomen.setTitle(Constants.btn_women, for: .normal)
            buttonFriendshipWomen.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonFriendshipWomen.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonFriendshipWomen.backgroundColor = Constants.color_GreyUnselectedBkg
            buttonFriendshipWomen.layer.cornerRadius = 8.0
        }
    }
    @IBOutlet weak var buttonFriendshipMen: UIButton!{
        didSet {
            buttonFriendshipMen.setTitle(Constants.btn_men, for: .normal)
            buttonFriendshipMen.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonFriendshipMen.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonFriendshipMen.backgroundColor = Constants.color_GreyUnselectedBkg
            buttonFriendshipMen.layer.cornerRadius = 8.0
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
        let pickactivityVC = PickActivityVC.loadFromNib()
        self.navigationController?.pushViewController(pickactivityVC, animated: true)
    }

    
}
//MARK: Extension UDF
extension RelationshipVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupProgressView()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_relationship
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
        let currentProgress = 4
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
}
