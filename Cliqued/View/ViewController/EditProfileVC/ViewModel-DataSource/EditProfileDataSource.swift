//
//  EditProfileDataSource.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit
import DropDown
import StepSlider
import SKPhotoBrowser
import AVKit
import AVFoundation
import SwiftUI

class EditProfileDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewController: EditProfileVC
    private let tableView: UITableView
    private let viewModel: EditProfileViewModel
    
    enum enumEditProfileTableRow: Int, CaseIterable {
        case profileImage = 0
        case name
        case aboutme
        case favoriteActivity
        case lookingFor
        case location
        case height
        case kids
        case smoking
        case distancePreference
        case agePreference
    }
    
    var callbackForKidsDropDownValue: ((_ seletedItem: String) -> Void)?
    var callbackForSmokingDropDownValue: ((_ seletedItem: String) -> Void)?
    let settingView = DropDown()
    private let mediaType = MediaType()
    private let preferenceTypeIds = PreferenceTypeIds()
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: EditProfileViewModel, viewController: EditProfileVC) {
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
        tableView.registerNib(nibNames: [UserProfileCell.identifier,BorderedTextFieldCell.identifier,ActivityDescriptionCell.identifier,FavoriteActivityCell.identifier,DropdownCell.identifier, TextViewCell.identifier])
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enumEditProfileTableRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumEditProfileTableRow(rawValue: indexPath.row)! {
        case .profileImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileCell.identifier) as!
            UserProfileCell
            cell.selectionStyle = .none
            cell.arrayOfUserProfile = viewModel.getUserProfileCollection()
            cell.collectionView.reloadData()
            cell.buttonEditProfileImage.tag = enumEditProfileTableRow.profileImage.rawValue
            cell.buttonEditProfileImage.addTarget(self, action: #selector(btnEditProfileImageTap(_:)), for: .touchUpInside)
            
            cell.callbackForViewMedia = { [weak self] isImageMedia, indexValue in
                guard let self = self else { return }
                
                if isImageMedia {
                    var images = [SKPhotoProtocol]()
                    for i in 0..<self.viewModel.getUserProfileCollection().count {
                        if self.viewModel.getUserProfileCollection()[i].mediaType == self.mediaType.image {
                            let photo = SKPhoto.photoWithImageURL(UrlProfileImage + (self.viewModel.getUserProfileCollection()[i].url ?? ""))
                            photo.shouldCachePhotoURLImage = true
                            images.append(photo)
                        }
                    }
                    // 2. create PhotoBrowser Instance, and present.
                    let browser = SKPhotoBrowser(photos: images)
                    SKPhotoBrowserOptions.displayAction = false
                    browser.initializePageIndex(indexValue)
                    self.viewController.present(browser, animated: true, completion: {})
                } else {
                    for i in 0..<self.viewModel.getUserProfileCollection().count {
                        if self.viewModel.getUserProfileCollection()[i].mediaType == self.mediaType.video {
                            let videoURL = URL(string: UrlProfileImage + (self.viewModel.getUserProfileCollection()[i].url ?? ""))
                            let player = AVPlayer(url: videoURL! as URL)
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = player
                            self.viewController.present(playerViewController, animated: true) {
                                playerViewController.player!.play()
                            }
                        }
                    }
                    
                }
            }
            
            return cell
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: BorderedTextFieldCell.identifier) as! BorderedTextFieldCell
            cell.selectionStyle = .none
            cell.labelTextFieldTitle.text = Constants.label_name
            cell.textfiled.placeholder = Constants.placeholder_name
            cell.textfiled.delegate = self
            cell.textfiled.tag = enumEditProfileTableRow.name.rawValue
            cell.buttonDropDown.isHidden = true
            cell.textfiled.text = viewModel.getName()
            return cell
        case .aboutme:
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityDescriptionCell.identifier) as! ActivityDescriptionCell
            cell.selectionStyle = .none
            cell.labelTextViewTitle.text = Constants.label_aboutMe
            cell.textview.tag = enumEditProfileTableRow.aboutme.rawValue
            cell.textview.delegate = self
            
            if viewModel.getAboutMe().isEmpty {
                cell.textview.text = Constants.placeholder_activityDescription
                cell.textview.textColor = Constants.color_MediumGrey
            } else {
                cell.textview.text = viewModel.getAboutMe()
                cell.textview.textColor = Constants.color_DarkGrey
            }
            return cell
        case .favoriteActivity:
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteActivityCell.identifier) as! FavoriteActivityCell
            cell.selectionStyle = .none
            cell.labelFavoriteActivityTitle.text = Constants.label_myFavoriteActivities
            cell.arrayOfFavoriteActivity = viewModel.getFavoriteCategoryActivity()
            cell.collectionview.reloadData()
            cell.buttonEditActivity.tag = enumEditProfileTableRow.favoriteActivity.rawValue
            cell.buttonEditActivity.addTarget(self, action: #selector(btnEditFavoriteActivityTap(_:)), for: .touchUpInside)
            
            let cellWidth = (cell.collectionview.frame.size.width) / 3
            let height = cellWidth + (cellWidth * 0.3)
            cell.constraintCollectionviewHeight.constant = height
            cell.layoutIfNeeded()
            return cell
        case .lookingFor:
            let cell = tableView.dequeueReusableCell(withIdentifier: DropdownCell.identifier) as! DropdownCell
            cell.selectionStyle = .none
            cell.labelDropdownTitle.text = Constants.label_lookingFor
            cell.imageviewRightIcon.isHidden = true
            cell.imageviewDropdownIcon.isHidden = false
            cell.imageviewDropdownIcon.image = UIImage(named: "ic_next_arrow")
            cell.textfiledDropdown.text = viewModel.getLookingFor()
            cell.buttonDropdown.removeTarget(nil, action: nil, for: .allEvents)
            cell.buttonDropdown.tag = enumEditProfileTableRow.lookingFor.rawValue
            cell.buttonDropdown.addTarget(self, action: #selector(btnLookingForTap(_:)), for: .touchUpInside)
            return cell
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.identifier) as! TextViewCell
            cell.selectionStyle = .none
            cell.labelTitle.text = Constants.label_location
            if viewModel.getLocation().count > 0 {
                let locationData = viewModel.getLocation().first
                cell.labelValue.text = "\(locationData?.address ?? ""), \(locationData?.city ?? ""), \(locationData?.state ?? ""), \(locationData?.country ?? ""), \(locationData?.pincode ?? "")"
            } else {
                cell.labelValue.text = "-"
            }
            cell.buttonClick.tag = enumEditProfileTableRow.location.rawValue
            cell.buttonClick.removeTarget(nil, action: nil, for: .allEvents)
            cell.buttonClick.addTarget(self, action: #selector(btnEditLocationTap(_:)), for: .touchUpInside)
            return cell
        case .height:
            let cell = tableView.dequeueReusableCell(withIdentifier: BorderedTextFieldCell.identifier) as! BorderedTextFieldCell
            cell.selectionStyle = .none
            cell.labelTextFieldTitle.text = "\(Constants.label_height) \(Constants.label_heightInCm)"
            cell.textfiled.placeholder = Constants.placeholder_height
            cell.textfiled.keyboardType = .numberPad
            cell.textfiled.delegate = self
            cell.textfiled.tag = enumEditProfileTableRow.height.rawValue
            cell.buttonDropDown.isHidden = true
            if viewModel.getHeight() != "0" {
                cell.textfiled.text = viewModel.getHeight()
            } else {
                cell.textfiled.text = "-"
            }
            
            return cell
        case .kids:
            let cell = tableView.dequeueReusableCell(withIdentifier: DropdownCell.identifier) as! DropdownCell
            cell.selectionStyle = .none
            cell.labelDropdownTitle.text = Constants.label_kids
            cell.imageviewRightIcon.isHidden = true
            cell.imageviewDropdownIcon.isHidden = false
            cell.imageviewDropdownIcon.image = UIImage(named: "ic_dropdown_arrow")
            if !viewModel.getKids().isEmpty {
                cell.textfiledDropdown.text = viewModel.getKids()
            } else {
                cell.textfiledDropdown.text = "No"
            }
            cell.buttonDropdown.tag = enumEditProfileTableRow.kids.rawValue
            cell.buttonDropdown.removeTarget(nil, action: nil, for: .allEvents)
            cell.buttonDropdown.addTarget(self, action: #selector(btnkidsDropdownTap(_:)), for: .touchUpInside)
            callbackForKidsDropDownValue = { item in
                cell.textfiledDropdown.text = item
            }
            return cell
        case .smoking:
            let cell = tableView.dequeueReusableCell(withIdentifier: DropdownCell.identifier) as! DropdownCell
            cell.selectionStyle = .none
            cell.labelDropdownTitle.text = Constants.label_smoking
            cell.imageviewRightIcon.isHidden = true
            cell.imageviewDropdownIcon.isHidden = false
            cell.imageviewDropdownIcon.image = UIImage(named: "ic_dropdown_arrow")
            if !viewModel.getSmoking().isEmpty {
                cell.textfiledDropdown.text = viewModel.getSmoking()
            } else {
                cell.textfiledDropdown.text = "No"
            }
            cell.buttonDropdown.tag = enumEditProfileTableRow.smoking.rawValue
            cell.buttonDropdown.removeTarget(nil, action: nil, for: .allEvents)
            cell.buttonDropdown.addTarget(self, action: #selector(btnSmokingDropdownTap(_:)), for: .touchUpInside)
            callbackForSmokingDropDownValue = { item in
                cell.textfiledDropdown.text = item
            }
            return cell
        case .distancePreference:
            return UITableViewCell()
        case .agePreference:
            return UITableViewCell()
        }
    }
    
    //MARK: Button Edit Profile Image
    @objc func btnEditProfileImageTap(_ sender: UIButton) {
        let selectpicturevc = UIHostingController(rootView: SelectPicturesView(arrayOfProfileImage: viewModel.getUserProfileCollection(), isFromEditProfile: true))
        viewController.navigationController?.pushViewController(selectpicturevc, animated: true)
    }
    
    //MARK: Button Looking For Tap
    @objc func btnLookingForTap(_ sender: UIButton) {
        let relationshipvc = UIHostingController(rootView: RelationshipView(isFromEditProfile: true, arrayOfUserPreference: viewModel.getUserPreferencesArray()))
        viewController.navigationController?.pushViewController(relationshipvc, animated: true)
    }
    
    //MARK: Button Edit Profile Image
    @objc func btnEditFavoriteActivityTap(_ sender: UIButton) {
        let pickActivityView = PickActivityView(isFromEditProfile: true, arrayOfActivity: viewModel.getFavoriteActivity())
        viewController.navigationController?.pushViewController(UIHostingController(rootView: pickActivityView), animated: true)
    }
    
    //MARK: Button Edit Profile Image
    @objc func btnEditLocationTap(_ sender: UIButton) {
        guard let locationData = viewModel.getLocation().first else { return }
        
        let setlocationvc = UIHostingController(rootView: LocationView(isFromEditProfile: true,
                                                                       addressId: "\(locationData.id ?? 0)",
                                                                       setlocationvc: viewModel.getDistancePreference(),
                                                                       objAddress: locationData))
        
        viewController.navigationController?.pushViewController(setlocationvc, animated: true)
    }
    
    //MARK: Button Kids Dropdown Tap
    @objc func btnkidsDropdownTap(_ sender: UIButton) {
        setupDropDownUI()
        let arrayOption = [Constants.label_titleYes, Constants.label_titleNo]
        
        settingView.dataSource = arrayOption
        settingView.width = sender.width
        settingView.anchorView = sender
        settingView.direction = .bottom
        settingView.bottomOffset = CGPoint(x: 0, y:(settingView.anchorView?.plainView.bounds.height)!)
        
        settingView.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            
            self.callbackForKidsDropDownValue?(item)
            
            var arrayOfPreference = [PreferenceClass]()
            var arrayOfTypeOption = [TypeOptions]()
            
            arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == self.preferenceTypeIds.kids}) ?? []
            if arrayOfPreference.count > 0 {
                arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
                if arrayOfTypeOption.count > 0 {
                    let subTypesData = arrayOfTypeOption.filter({$0.title == item})
                    let prefId = subTypesData[0].preferenceId
                    let optionId = subTypesData[0].id
                    self.viewModel.setKidsPrefId(value: prefId ?? 0)
                    self.viewModel.setKidsOptionId(value: optionId ?? 0)
                }
            }
            self.settingView.hide()
        }
        settingView.show()
    }
    
    //MARK: Button Smoking Dropdown Tap
    @objc func btnSmokingDropdownTap(_ sender: UIButton) {
        setupDropDownUI()
        let arrayOption = [Constants.label_titleYes, Constants.label_titleNo]
        settingView.dataSource = arrayOption
        settingView.width = sender.width
        settingView.anchorView = sender
        settingView.direction = .bottom
        settingView.bottomOffset = CGPoint(x: 0, y:(settingView.anchorView?.plainView.bounds.height)!)
        
        settingView.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            
            self.callbackForSmokingDropDownValue?(item)
            
            var arrayOfPreference = [PreferenceClass]()
            var arrayOfTypeOption = [TypeOptions]()
            
            arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == self.preferenceTypeIds.smoking}) ?? []
            if arrayOfPreference.count > 0 {
                arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
                if arrayOfTypeOption.count > 0 {
                    let subTypesData = arrayOfTypeOption.filter({$0.title == item})
                    let prefId = subTypesData[0].preferenceId
                    let optionId = subTypesData[0].id
                    self.viewModel.setSmokingPrefId(value: prefId ?? 0)
                    self.viewModel.setSmokingOptionId(value: optionId ?? 0)
                }
            }
            self.settingView.hide()
        }
        settingView.show()
    }
    
    //MARK: Dropdown Popup UI
    func setupDropDownUI() {
        let appearance = DropDown.appearance()
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = Constants.color_DarkGrey
        appearance.textFont = CustomFont.THEME_FONT_Medium(16)!
        appearance.cellHeight = 70
        appearance.separatorColor = Constants.color_MediumGrey
        appearance.backgroundColor = Constants.color_white
    }
}
//MARK: Extension TextField Delegate
extension EditProfileDataSource: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch enumEditProfileTableRow(rawValue: textField.tag) {
        case .name:
            viewModel.setName(value: textField.text ?? "")
        case .height:
            if textField.text == "" {
                viewModel.setHeight(value: "0")
            } else {
                viewModel.setHeight(value: textField.text ?? "")
            }
        default:
            break
        }
    }
}
//MARK: --------------------------------------------------
//MARK: Extension Textview Delegate
extension EditProfileDataSource : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Constants.color_MediumGrey {
            textView.text = nil
            textView.textColor = Constants.color_DarkGrey
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.setAboutMe(value: (textView.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.placeholder_activityDescription
            textView.textColor = Constants.color_MediumGrey
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
            return false
        }
        let substringToReplace = textView.text[rangeOfTextToReplace]
        let count = textView.text.count - substringToReplace.count + text.count
        return count <= 200
    }
}





