//
//  RelationshipVC.swift
//  Cliqued
//
//  Created by C211 on 16/01/23.
//

import UIKit

class RelationshipVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
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
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var buttonRomance: UIButton!{
        didSet {
            buttonRomance.setTitle(Constants.btn_romance, for: .normal)
            buttonRomance.setImage(UIImage(named: "ic_romance_black"), for: .normal)
            buttonRomance.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonRomance.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonRomance.backgroundColor = Constants.color_GreyUnselectedBkg
            buttonRomance.layer.cornerRadius = 8.0
            buttonRomance.titleLabel?.adjustsFontSizeToFitWidth = true
            buttonRomance.titleLabel?.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet weak var labelwith1: UILabel!{
        didSet {
            labelwith1.text = Constants.label_with
            labelwith1.font = CustomFont.THEME_FONT_Medium(15)
            labelwith1.textColor = Constants.color_DarkGrey
            labelwith1.adjustsFontSizeToFitWidth = true
            labelwith1.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet weak var buttonRomanceWomen: UIButton!{
        didSet {
            buttonRomanceWomen.setTitle(Constants.btn_women, for: .normal)
            buttonRomanceWomen.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonRomanceWomen.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonRomanceWomen.backgroundColor = Constants.color_GreyUnselectedBkg
            buttonRomanceWomen.layer.cornerRadius = 8.0
            buttonRomanceWomen.titleLabel?.adjustsFontSizeToFitWidth = true
            buttonRomanceWomen.titleLabel?.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet weak var buttonRomanceMen: UIButton!{
        didSet {
            buttonRomanceMen.setTitle(Constants.btn_men, for: .normal)
            buttonRomanceMen.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonRomanceMen.setTitleColor(Constants.color_white, for: .normal)
            buttonRomanceMen.backgroundColor = Constants.color_GreenSelectedBkg
            buttonRomanceMen.layer.cornerRadius = 8.0
            buttonRomanceMen.titleLabel?.adjustsFontSizeToFitWidth = true
            buttonRomanceMen.titleLabel?.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet weak var buttonFriendship: UIButton!{
        didSet {
            buttonFriendship.setTitle(Constants.btn_friendship, for: .normal)
            buttonFriendship.setImage(UIImage(named: "ic_friendship_black"), for: .normal)
            buttonFriendship.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonFriendship.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonFriendship.backgroundColor = Constants.color_GreyUnselectedBkg
            buttonFriendship.layer.cornerRadius = 8.0
            buttonFriendship.titleLabel?.adjustsFontSizeToFitWidth = true
            buttonFriendship.titleLabel?.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet weak var labelwith2: UILabel!{
        didSet {
            labelwith2.text = Constants.label_with
            labelwith2.font = CustomFont.THEME_FONT_Medium(15)
            labelwith2.textColor = Constants.color_DarkGrey
            labelwith2.adjustsFontSizeToFitWidth = true
            labelwith2.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet weak var buttonFriendshipWomen: UIButton!{
        didSet {
            buttonFriendshipWomen.setTitle(Constants.btn_women, for: .normal)
            buttonFriendshipWomen.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonFriendshipWomen.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonFriendshipWomen.backgroundColor = Constants.color_GreyUnselectedBkg
            buttonFriendshipWomen.layer.cornerRadius = 8.0
            buttonFriendshipWomen.titleLabel?.adjustsFontSizeToFitWidth = true
            buttonFriendshipWomen.titleLabel?.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet weak var buttonFriendshipMen: UIButton!{
        didSet {
            buttonFriendshipMen.setTitle(Constants.btn_men, for: .normal)
            buttonFriendshipMen.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonFriendshipMen.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonFriendshipMen.backgroundColor = Constants.color_GreyUnselectedBkg
            buttonFriendshipMen.layer.cornerRadius = 8.0
            buttonFriendshipMen.titleLabel?.adjustsFontSizeToFitWidth = true
            buttonFriendshipMen.titleLabel?.minimumScaleFactor = 0.5
        }
    }
    
    //MARK: Variable
    var isSelectedRomance: Bool = false
    var isSelectedFriendship: Bool = false
    
    var isSelectedRomanceWomen: Bool = false
    var isSelectedRomanceMen: Bool = false
    var isSelectedFriendshipWomen: Bool = false
    var isSelectedFriendshipMen: Bool = false
    lazy var viewModel = SignUpProcessViewModel()
    var isFromEditProfile: Bool = false
    var arrayOfUserPreference = [UserPreferences]()
    var arrayOfDeletedIds = [Int]()
    private let preferenceTypeIds = PreferenceTypeIds()
    private let genderTypeIds = GenderTypeIds()
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
    
    //MARK: BUTTON ROMANCE TAP
    @IBAction func btnRomanceTap(_ sender: Any) {
        if !isSelectedRomance {
            isSelectedRomance = true
        } else {
            isSelectedRomance = false
        }
        RomanceButtonUI(buttonName: buttonRomance, buttonTitle: Constants.btn_romance)
    }
    
    //MARK: Button Roamnce Women Tap
    @IBAction func btnRomanceWomenTap(_ sender: Any) {
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfSubType = [SubTypes]()
        var arrayOfTypeOption = [TypeOptions]()
        
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == preferenceTypeIds.looking_for}) ?? []
        if arrayOfPreference.count > 0 {
            arrayOfSubType = arrayOfPreference[0].subTypes ?? []
            if arrayOfSubType.count > 0 {
                let subTypesData = arrayOfSubType.filter({$0.typesOfPreference == preferenceTypeIds.romance})
                arrayOfTypeOption = subTypesData[0].typeOptions ?? []
                if arrayOfTypeOption.count > 0 {
                    arrayOfTypeOption = arrayOfTypeOption.filter({$0.typeOfOptions == genderTypeIds.Women})
                }
            }
        }
        
        if !isSelectedRomanceWomen {
            isSelectedRomanceWomen = true
            isSelectedRomance = true
            selectedGenderBtnUI(buttonName: buttonRomanceWomen, buttonTitle: Constants.btn_women)
            let prefId = arrayOfTypeOption[0].preferenceId?.description ?? ""
            let prefOptionId = arrayOfTypeOption[0].id?.description ?? ""
            var userPrefId = "0"
            
            //For edit time
            if isFromEditProfile {
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefId = array[0].id?.description ?? ""
                    }
                }
            }
        
            addDataInDictionary(prefId: prefId, prefOptionId: prefOptionId, UserPrefId: userPrefId)
            
            //For edit time manage delete Ids array
            if isFromEditProfile {
                var userPrefDeleteId = 0
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefDeleteId = array[0].id ?? 0
                    }
                }
                if let index = arrayOfDeletedIds.firstIndex(where: {$0 == userPrefDeleteId}) {
                    self.arrayOfDeletedIds.remove(at: index)
                }
            }
        } else {
            isSelectedRomanceWomen = false
            isSelectedRomance = false
            unselectedGenderBtnUI(buttonName: buttonRomanceWomen, buttonTitle: Constants.btn_women)
            
            let prefId = arrayOfTypeOption[0].preferenceId?.description ?? ""
            let prefOptionId = arrayOfTypeOption[0].id?.description ?? ""
            removeDataFromDictionary(prefId: prefId, prefOptionId: prefOptionId)
            
            //For edit time manage delete Ids array
            if isFromEditProfile {
                var userPrefId = 0
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefId = array[0].id ?? 0
                        arrayOfDeletedIds.append(userPrefId)
                    }
                }
            }
        }
        RomanceButtonUI(buttonName: buttonRomance, buttonTitle: Constants.btn_romance)
    }
    
    //MARK: Button Romance Men Tap
    @IBAction func btnRomanceMenTap(_ sender: Any) {
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfSubType = [SubTypes]()
        var arrayOfTypeOption = [TypeOptions]()
        
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == preferenceTypeIds.looking_for}) ?? []
        if arrayOfPreference.count > 0 {
            arrayOfSubType = arrayOfPreference[0].subTypes ?? []
            if arrayOfSubType.count > 0 {
                let subTypesData = arrayOfSubType.filter({$0.typesOfPreference == preferenceTypeIds.romance})
                arrayOfTypeOption = subTypesData[0].typeOptions ?? []
                if arrayOfTypeOption.count > 0 {
                    arrayOfTypeOption = arrayOfTypeOption.filter({$0.typeOfOptions == genderTypeIds.Men})
                }
            }
        }
        
        if !isSelectedRomanceMen {
            isSelectedRomance = true
            isSelectedRomanceMen = true
            selectedGenderBtnUI(buttonName: buttonRomanceMen, buttonTitle: Constants.btn_men)
            let prefId = arrayOfTypeOption[0].preferenceId?.description ?? ""
            let prefOptionId = arrayOfTypeOption[0].id?.description ?? ""
            var userPrefId = "0"
            
            //For edit time
            if isFromEditProfile {
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefId = array[0].id?.description ?? ""
                    }
                }
            }
            
            addDataInDictionary(prefId: prefId, prefOptionId: prefOptionId, UserPrefId: userPrefId)
            
            //For edit time manage delete Ids array
            if isFromEditProfile {
                var userPrefDeleteId = 0
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefDeleteId = array[0].id ?? 0
                    }
                }
                if let index = arrayOfDeletedIds.firstIndex(where: {$0 == userPrefDeleteId}) {
                    self.arrayOfDeletedIds.remove(at: index)
                }
            }
        } else {
            isSelectedRomance = false
            isSelectedRomanceMen = false
            unselectedGenderBtnUI(buttonName: buttonRomanceMen, buttonTitle: Constants.btn_men)
            
            let prefId = arrayOfTypeOption[0].preferenceId?.description ?? ""
            let prefOptionId = arrayOfTypeOption[0].id?.description ?? ""
            removeDataFromDictionary(prefId: prefId, prefOptionId: prefOptionId)
            
            //For edit time manage delete Ids array
            if isFromEditProfile {
                var userPrefId = 0
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefId = array[0].id ?? 0
                        arrayOfDeletedIds.append(userPrefId)
                    }
                }
                
            }
        }
        RomanceButtonUI(buttonName: buttonRomance, buttonTitle: Constants.btn_romance)
    }
    
    //MARK: BUTTON FRIENDSHIP TAP
    @IBAction func btnFriendshipTap(_ sender: Any) {
        if !isSelectedFriendship {
            isSelectedFriendship = true
        } else {
            isSelectedFriendship = false
        }
        FriendshipButtonUI(buttonName: buttonFriendship, buttonTitle: Constants.btn_friendship)
    }
    
    //MARK: Button Friendship Women Tap
    @IBAction func btnFriendshipWomenTap(_ sender: Any) {
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfSubType = [SubTypes]()
        var arrayOfTypeOption = [TypeOptions]()
        
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == preferenceTypeIds.looking_for}) ?? []
        if arrayOfPreference.count > 0 {
            arrayOfSubType = arrayOfPreference[0].subTypes ?? []
            if arrayOfSubType.count > 0 {
                let subTypesData = arrayOfSubType.filter({$0.typesOfPreference == preferenceTypeIds.friendship})
                arrayOfTypeOption = subTypesData[0].typeOptions ?? []
                if arrayOfTypeOption.count > 0 {
                    arrayOfTypeOption = arrayOfTypeOption.filter({$0.typeOfOptions == genderTypeIds.Women})
                }
            }
        }
        
        if !isSelectedFriendshipWomen {
            isSelectedFriendship = true
            isSelectedFriendshipWomen = true
            selectedGenderBtnUI(buttonName: buttonFriendshipWomen, buttonTitle: Constants.btn_women)
            let prefId = arrayOfTypeOption[0].preferenceId?.description ?? ""
            let prefOptionId = arrayOfTypeOption[0].id?.description ?? ""
            var userPrefId = "0"
            
            //For edit time
            if isFromEditProfile {
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefId = array[0].id?.description ?? ""
                    }
                }
            }
        
            addDataInDictionary(prefId: prefId, prefOptionId: prefOptionId, UserPrefId: userPrefId)
            
            //For edit time manage delete Ids array
            if isFromEditProfile {
                var userPrefDeleteId = 0
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefDeleteId = array[0].id ?? 0
                    }
                }
                if let index = arrayOfDeletedIds.firstIndex(where: {$0 == userPrefDeleteId}) {
                    self.arrayOfDeletedIds.remove(at: index)
                }
            }
        } else {
            isSelectedFriendship = false
            isSelectedFriendshipWomen = false
            unselectedGenderBtnUI(buttonName: buttonFriendshipWomen, buttonTitle: Constants.btn_women)
            
            let prefId = arrayOfTypeOption[0].preferenceId?.description ?? ""
            let prefOptionId = arrayOfTypeOption[0].id?.description ?? ""
            removeDataFromDictionary(prefId: prefId, prefOptionId: prefOptionId)
            
            //For edit time manage delete Ids array
            if isFromEditProfile {
                var userPrefId = 0
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefId = array[0].id ?? 0
                        arrayOfDeletedIds.append(userPrefId)
                    }
                }
                
            }
        }
        FriendshipButtonUI(buttonName: buttonFriendship, buttonTitle: Constants.btn_friendship)
    }
    
    //MARK: Button Friendship Men Tap
    @IBAction func btnFriendshipMenTap(_ sender: Any) {
        
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfSubType = [SubTypes]()
        var arrayOfTypeOption = [TypeOptions]()
        
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == preferenceTypeIds.looking_for}) ?? []
        if arrayOfPreference.count > 0 {
            arrayOfSubType = arrayOfPreference[0].subTypes ?? []
            if arrayOfSubType.count > 0 {
                let subTypesData = arrayOfSubType.filter({$0.typesOfPreference == preferenceTypeIds.friendship})
                arrayOfTypeOption = subTypesData[0].typeOptions ?? []
                if arrayOfTypeOption.count > 0 {
                    arrayOfTypeOption = arrayOfTypeOption.filter({$0.typeOfOptions == genderTypeIds.Men})
                }
            }
        }
        
        if !isSelectedFriendshipMen {
            isSelectedFriendship = true
            isSelectedFriendshipMen = true
            selectedGenderBtnUI(buttonName: buttonFriendshipMen, buttonTitle: Constants.btn_men)
            let prefId = arrayOfTypeOption[0].preferenceId?.description ?? ""
            let prefOptionId = arrayOfTypeOption[0].id?.description ?? ""
            var userPrefId = "0"
            
            //For edit time
            if isFromEditProfile {
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefId = array[0].id?.description ?? ""
                    }
                }
            }
        
            addDataInDictionary(prefId: prefId, prefOptionId: prefOptionId, UserPrefId: userPrefId)
            
            //For edit time manage delete Ids array
            if isFromEditProfile {
                var userPrefDeleteId = 0
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefDeleteId = array[0].id ?? 0
                    }
                }
                if let index = arrayOfDeletedIds.firstIndex(where: {$0 == userPrefDeleteId}) {
                    self.arrayOfDeletedIds.remove(at: index)
                }
            }
        } else {
            isSelectedFriendship = false
            isSelectedFriendshipMen = false
            unselectedGenderBtnUI(buttonName: buttonFriendshipMen, buttonTitle: Constants.btn_men)
           
            let prefId = arrayOfTypeOption[0].preferenceId?.description ?? ""
            let prefOptionId = arrayOfTypeOption[0].id?.description ?? ""
            removeDataFromDictionary(prefId: prefId, prefOptionId: prefOptionId)
            //For edit time manage delete Ids array
            if isFromEditProfile {
                var userPrefId = 0
                if arrayOfUserPreference.contains(where: {$0.preferenceOptionId == Int(prefOptionId)}) {
                    let array = arrayOfUserPreference.filter({$0.preferenceOptionId == Int(prefOptionId)})
                    if array.count > 0 {
                        userPrefId = array[0].id ?? 0
                        arrayOfDeletedIds.append(userPrefId)
                    }
                }
                
            }
        }
        FriendshipButtonUI(buttonName: buttonFriendship, buttonTitle: Constants.btn_friendship)
    }
    
    //MARK: Button Continue Click Event
    @IBAction func btnContinueTap(_ sender: Any) {
        if !isFromEditProfile {
            viewModel.setProfileSetupType(value: profileSetupType.relationship)
        } else {
            viewModel.setProfileSetupType(value: profileSetupType.completed)
        }
        if viewModel.getRelationship().count > 0 {
            if isFromEditProfile {
                let deleteIds = arrayOfDeletedIds.map({String($0)}).joined(separator: ", ")
                viewModel.setDeletedLookingForIds(value: deleteIds)
            }
            viewModel.callSignUpProcessAPI()
        } else {
            showAlertPopup(message: Constants.validMsg_relationship)
        }
        print(viewModel.getRelationship())
        print(viewModel.getDeletedLookingForIds())
    }
}
//MARK: Extension UDF
extension RelationshipVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupProgressView()
        setupAllButtonDisable()
        if isFromEditProfile {
            bindRelationshipDataForEditTime()
        }
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_relationship
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonSkip.addTarget(self, action: #selector(buttonSkipTap), for: .touchUpInside)
        
        if !isFromEditProfile {
            progressView.isHidden = false
            viewNavigationBar.buttonBack.isHidden = true
            viewNavigationBar.buttonRight.isHidden = true
            viewNavigationBar.buttonSkip.isHidden = false
        } else {
            progressView.isHidden = true
            viewNavigationBar.buttonBack.isHidden = false
            viewNavigationBar.buttonRight.isHidden = true
            viewNavigationBar.buttonSkip.isHidden = true
        }
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
        let currentProgress = 4
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
    //MARK: Setup all button disable mode on initial stage.
    func setupAllButtonDisable() {
        unselectedGenderBtnUI(buttonName: buttonRomanceMen, buttonTitle: Constants.btn_men)
        unselectedGenderBtnUI(buttonName: buttonRomanceWomen, buttonTitle: Constants.btn_women)
        unselectedGenderBtnUI(buttonName: buttonFriendshipMen, buttonTitle: Constants.btn_men)
        unselectedGenderBtnUI(buttonName: buttonFriendshipWomen, buttonTitle: Constants.btn_women)
    }
    //MARK: UI Of Selected Button
    func selectedGenderBtnUI(buttonName: UIButton, buttonTitle: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
        buttonName.setTitleColor(Constants.color_white, for: .normal)
        buttonName.backgroundColor = Constants.color_GreenSelectedBkg
        buttonName.layer.cornerRadius = 10.0
    }
    //MARK: UI Of Un-selected Button
    func unselectedGenderBtnUI(buttonName: UIButton, buttonTitle: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
        buttonName.setTitleColor(Constants.color_DarkGrey, for: .normal)
        buttonName.backgroundColor = Constants.color_GreyUnselectedBkg
        buttonName.layer.cornerRadius = 10.0
    }
    //MARK: UI Of Romance Main Button
    func RomanceButtonUI(buttonName: UIButton, buttonTitle: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
        buttonName.layer.cornerRadius = 10.0
        
//        if isSelectedRomance {
//            buttonName.setImage(UIImage(named: "ic_romance_white"), for: .normal)
//            buttonName.setTitleColor(Constants.color_white, for: .normal)
//            buttonName.backgroundColor = Constants.color_GreenSelectedBkg
//        } else {
//            buttonName.setImage(UIImage(named: "ic_romance_black"), for: .normal)
//            buttonName.setTitleColor(Constants.color_DarkGrey, for: .normal)
//            buttonName.backgroundColor = Constants.color_GreyUnselectedBkg
//        }
        
        
        if isSelectedRomanceWomen || isSelectedRomanceMen || isSelectedRomance {
            buttonName.setImage(UIImage(named: "ic_romance_white"), for: .normal)
            buttonName.setTitleColor(Constants.color_white, for: .normal)
            buttonName.backgroundColor = Constants.color_GreenSelectedBkg
        } else {
            buttonName.setImage(UIImage(named: "ic_romance_black"), for: .normal)
            buttonName.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonName.backgroundColor = Constants.color_GreyUnselectedBkg
        }
    }
    //MARK: UI Of Friendship Main Button
    func FriendshipButtonUI(buttonName: UIButton, buttonTitle: String) {
        buttonName.setTitle(buttonTitle, for: .normal)
        buttonName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
        buttonName.layer.cornerRadius = 10.0
        
//        if isSelectedFriendship {
//            buttonName.setImage(UIImage(named: "ic_friendship_white"), for: .normal)
//            buttonName.setTitleColor(Constants.color_white, for: .normal)
//            buttonName.backgroundColor = Constants.color_GreenSelectedBkg
//        } else {
//            buttonName.setImage(UIImage(named: "ic_friendship_black"), for: .normal)
//            buttonName.setTitleColor(Constants.color_DarkGrey, for: .normal)
//            buttonName.backgroundColor = Constants.color_GreyUnselectedBkg
//        }
        
        if isSelectedFriendshipWomen || isSelectedFriendshipMen || isSelectedFriendship  {
            buttonName.setImage(UIImage(named: "ic_friendship_white"), for: .normal)
            buttonName.setTitleColor(Constants.color_white, for: .normal)
            buttonName.backgroundColor = Constants.color_GreenSelectedBkg
        } else {
            buttonName.setImage(UIImage(named: "ic_friendship_black"), for: .normal)
            buttonName.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonName.backgroundColor = Constants.color_GreyUnselectedBkg
        }
    }
    //MARK: Bind relationship data in edit profile yime
    func bindRelationshipDataForEditTime() {
        if arrayOfUserPreference.count > 0 {
            for userPreference in arrayOfUserPreference {
                if userPreference.typesOfPreference == preferenceTypeIds.looking_for {
                    if userPreference.subTypesOfPreference == preferenceTypeIds.romance {
                        if (userPreference.typesOfOptions == genderTypeIds.Men) && (userPreference.subTypesOfPreference == preferenceTypeIds.romance) {
                            isSelectedRomanceMen = true
                            selectedGenderBtnUI(buttonName: buttonRomanceMen, buttonTitle: Constants.btn_men)
                            
                            let prefId = userPreference.preferenceId?.description ?? ""
                            let prefOptionId = userPreference.preferenceOptionId?.description ?? ""
                            let userPrefId = userPreference.id?.description ?? ""
                            addDataInDictionary(prefId: prefId, prefOptionId: prefOptionId, UserPrefId: userPrefId)
                        }
                        if (userPreference.typesOfOptions == genderTypeIds.Women) && (userPreference.subTypesOfPreference == preferenceTypeIds.romance) {
                            isSelectedRomanceWomen = true
                            selectedGenderBtnUI(buttonName: buttonRomanceWomen, buttonTitle: Constants.btn_women)
                            
                            let prefId = userPreference.preferenceId?.description ?? ""
                            let prefOptionId = userPreference.preferenceOptionId?.description ?? ""
                            let userPrefId = userPreference.id?.description ?? ""
                            addDataInDictionary(prefId: prefId, prefOptionId: prefOptionId, UserPrefId: userPrefId)
                        }
                        RomanceButtonUI(buttonName: buttonRomance, buttonTitle: Constants.btn_romance)
                    }
                    
                    if userPreference.subTypesOfPreference == preferenceTypeIds.friendship {
                        if (userPreference.typesOfOptions == genderTypeIds.Men) && (userPreference.subTypesOfPreference == preferenceTypeIds.friendship) {
                            isSelectedFriendshipMen = true
                            selectedGenderBtnUI(buttonName: buttonFriendshipMen, buttonTitle: Constants.btn_men)
                            
                            let prefId = userPreference.preferenceId?.description ?? ""
                            let prefOptionId = userPreference.preferenceOptionId?.description ?? ""
                            let userPrefId = userPreference.id?.description ?? ""
                            addDataInDictionary(prefId: prefId, prefOptionId: prefOptionId, UserPrefId: userPrefId)
                        }
                        if (userPreference.typesOfOptions == genderTypeIds.Women) && (userPreference.subTypesOfPreference == preferenceTypeIds.friendship) {
                            isSelectedFriendshipWomen = true
                            selectedGenderBtnUI(buttonName: buttonFriendshipWomen, buttonTitle: Constants.btn_women)
                            
                            let prefId = userPreference.preferenceId?.description ?? ""
                            let prefOptionId = userPreference.preferenceOptionId?.description ?? ""
                            let userPrefId = userPreference.id?.description ?? ""
                            addDataInDictionary(prefId: prefId, prefOptionId: prefOptionId, UserPrefId: userPrefId)
                        }
                        FriendshipButtonUI(buttonName: buttonFriendship, buttonTitle: Constants.btn_friendship)
                    }
                }
            }
        }
    }
    //MARK: Add data in dictionary for param.
    func addDataInDictionary(prefId: String, prefOptionId: String, UserPrefId: String) {
        var dict1 = structRelationshipParam()
        dict1.preference_id = prefId
        dict1.preference_option_id = prefOptionId
        dict1.user_preference_id = UserPrefId
        viewModel.setRelationship(value: dict1)
    }
    //MARK: Remove data in dictionary for param.
    func removeDataFromDictionary(prefId: String, prefOptionId: String) {
        let prefId = prefId
        let prefOptionId = prefOptionId
        let arrayOfRelationship = viewModel.getRelationship()
        if let index = arrayOfRelationship.firstIndex(where: {$0.preference_id == prefId && $0.preference_option_id == prefOptionId}) {
            viewModel.removeSelectedRelationship(Index: index)
        }
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
                if !self.isFromEditProfile {
                    let pickactivityVC = PickActivityVC.loadFromNib()
                    self.navigationController?.pushViewController(pickactivityVC, animated: true)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("refreshProfileData"), object: nil, userInfo:nil)
                    let editprofilevc = EditProfileVC.loadFromNib()
                    editprofilevc.isUpdateData = true
                    self.navigationController?.pushViewController(editprofilevc, animated: true)
                }
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
