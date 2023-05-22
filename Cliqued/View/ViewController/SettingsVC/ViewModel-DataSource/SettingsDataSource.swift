//
//  SettingsDataSource.swift
//  Cliqued
//
//  Created by C211 on 23/01/23.
//

import UIKit
import StoreKit
import SafariServices

class SettingsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private let viewController: SettingsVC
    private let tableView: UITableView
    private let viewModel: SettingsViewModel
    private let loginType = LoginType()
    
    //MARK: Enum Section
    enum enumSettingsTableSection: Int, CaseIterable {
        case accountSetting = 0
        case subscription
        case connection
        case activeStatus
        case notification
        case otherSettings
        case contactUs
        case community
        case privacy
        case legal
    }
    
    //MARK: Enum Active Status Row
    enum enumSocialAccountSettingsRow: Int, CaseIterable {
        case email = 0
    }
    enum enumAccountSettingsRow: Int, CaseIterable {
        case email = 0
        case password
//        case connectedAccounts
    }
    //MARK: Enum Active Status Row
    enum enumActiveStatusRow: Int, CaseIterable {
        case onlineNow = 0
        case lastSeenStatus
    }
    //MARK: Enum Notification Row
    enum enumNotificationsRow: Int, CaseIterable {
        case emailNotifications = 0
        case pushNotifications
    }
    //MARK: Enum Other Settings Row
    enum enumOtherSettingsRow: Int, CaseIterable {
        case restorePurchase = 0
        case inviteFriends
//        case language
    }
    //MARK: Enum Coummunity Row
    enum enumCommunityRow: Int, CaseIterable {
        case communityGuidelines = 0
        case safetyTips
//        case safetyCenter
    }
    //MARK: Enum Privacy Row
    enum enumPrivacyRow: Int, CaseIterable {
        case cookiePolicy = 0
        case privacyPolicy
//        case privacyPreference
    }
    //MARK: Enum Legal Row
    enum enumLegalRow: Int, CaseIterable {
        case termsOfService = 0
        case licenses
    }
    
    //MARK:- Init
    init(tableView: UITableView, viewModel: SettingsViewModel, viewController: SettingsVC) {
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
        tableView.registerNib(nibNames: [SettingsSectionCell.identifier, EmailAndPasswordCell.identifier, SettingsRowCell.identifier])
        tableView.reloadData()
    }
    
    func selectLanguage() {
        let arraySelect = [Constants_Message.title_english, Constants_Message.title_french, Constants_Message.title_german, Constants_Message.title_italian]
        
        let arrayIndexSelect = [Language1.en.rawValue, Language1.fr.rawValue, Language1.de.rawValue, Language1.it.rawValue]

        let alert = UIAlertController(title: nil, message: Constants_Message.title_select_language, preferredStyle: .alert)
        
            let closure = { [weak self] (action: UIAlertAction!) -> Void in
                guard let self = self else { return }
                
                let index = alert.actions.firstIndex(of: action)

                if index != nil {
                    NSLog("Index: \(index!)")
                    
                    self.viewController.selectedLanguage = arraySelect[index!]
                    UserDefaults.standard.set( arrayIndexSelect[index!], forKey: USER_DEFAULT_KEYS.kUserLanguage)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10), execute: {
                        APP_DELEGATE.setRootViewController()
                        NotificationCenter.default.post(name: .languageChange, object: nil)
                    })
                }
            }

            for field in arraySelect {
                alert.addAction(UIAlertAction(title: field, style: .default, handler: closure))
            }

        alert.addAction(UIAlertAction(title: Constants_Message.cancel_title, style: .destructive, handler: {(_) in }))

            self.viewController.present(alert, animated: true)

    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        
        switch mySwitch.tag {
        case enumActiveStatusRow.onlineNow.rawValue:
            let value = mySwitch.isOn
            viewModel.setIsOnline(value: value == true ? "1" : "0")
            viewModel.apiUpdateUserChatStatus()
            break
            
        case enumActiveStatusRow.lastSeenStatus.rawValue:
            let value = mySwitch.isOn
            viewModel.setIsLastSeen(value: value == true ? "1" : "0")
            viewModel.apiUpdateUserChatStatus()
            break
            
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return enumSettingsTableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch enumSettingsTableSection(rawValue: section)! {
        case .accountSetting:
            return enumAccountSettingsRow.allCases.count
        case .subscription:
            return 1
        case .connection:
            return 1
        case .activeStatus:
            return enumActiveStatusRow.allCases.count
        case .notification:
            return enumNotificationsRow.allCases.count
        case .otherSettings:
            return enumOtherSettingsRow.allCases.count
        case .contactUs:
            return 1
        case .community:
            return enumCommunityRow.allCases.count
        case .privacy:
            return enumPrivacyRow.allCases.count
        case .legal:
            return enumLegalRow.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "SettingsSectionCell") as! SettingsSectionCell
        headerCell.selectionStyle = .none
        switch enumSettingsTableSection(rawValue: section)! {
        case .accountSetting:
            headerCell.labelSectionTitle.text = Constants.labelSettingSectionTitle_accountSetting
            headerCell.labelBasicAccountTitle.isHidden = true
            return headerCell
        case .subscription:
            headerCell.labelSectionTitle.text = Constants.labelSettingSectionTitle_subscription
            headerCell.labelBasicAccountTitle.isHidden = false
            return headerCell
        case .connection:
            headerCell.labelSectionTitle.text = Constants.labelSettingSectionTitle_connections
            headerCell.labelBasicAccountTitle.isHidden = true
            return headerCell
        case .activeStatus:
            headerCell.labelSectionTitle.text = Constants.labelSettingSectionTitle_activeStatus
            headerCell.labelBasicAccountTitle.isHidden = true
            return headerCell
        case .notification:
            headerCell.labelSectionTitle.text = Constants.labelSettingSectionTitle_notifications
            headerCell.labelBasicAccountTitle.isHidden = true
            return headerCell
        case .otherSettings:
            headerCell.labelSectionTitle.text = Constants.labelSettingSectionTitle_otherSettings
            headerCell.labelBasicAccountTitle.isHidden = true
            return headerCell
        case .contactUs:
            headerCell.labelSectionTitle.text = Constants.labelSettingSectionTitle_contactUs
            headerCell.labelBasicAccountTitle.isHidden = true
            return headerCell
        case .community:
            headerCell.labelSectionTitle.text = Constants.labelSettingSectionTitle_community
            headerCell.labelBasicAccountTitle.isHidden = true
            return headerCell
        case .privacy:
            headerCell.labelSectionTitle.text = Constants.labelSettingSectionTitle_privacy
            headerCell.labelBasicAccountTitle.isHidden = true
            return headerCell
        case .legal:
            headerCell.labelSectionTitle.text = Constants.labelSettingSectionTitle_legal
            headerCell.labelBasicAccountTitle.isHidden = true
            return headerCell
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch enumSettingsTableSection(rawValue: indexPath.section)! {
        case .accountSetting:
            switch enumAccountSettingsRow(rawValue: indexPath.row)! {
            case .email:
                let cell = tableView.dequeueReusableCell(withIdentifier: EmailAndPasswordCell.identifier) as! EmailAndPasswordCell
                cell.selectionStyle = .none
                cell.labelEmailPasswordTitle.text = Constants.label_email
                cell.labelEmailPasswordValue.text = Constants.loggedInUser?.connectedAccount![0].emailId
                cell.imageviewBottomLine.isHidden = false
                
                if Constants.loggedInUser?.connectedAccount![0].loginType == loginType.NORMAL {
                    cell.imageviewNextArrow.isHidden = false
                } else {
                    cell.imageviewNextArrow.isHidden = true
                }
                
                return cell
            case .password:
                let cell = tableView.dequeueReusableCell(withIdentifier: EmailAndPasswordCell.identifier) as! EmailAndPasswordCell
                cell.selectionStyle = .none
                cell.labelEmailPasswordTitle.text = Constants.label_password
                cell.imageviewBottomLine.isHidden = false
                
                if Constants.loggedInUser?.connectedAccount![0].loginType == loginType.NORMAL {
                    cell.imageviewNextArrow.isHidden = false
                    cell.labelEmailPasswordValue.text = "xxxxxxxxxxxxx"
                } else {
                    cell.imageviewNextArrow.isHidden = true
                    cell.labelEmailPasswordValue.text = "-"
                }
                
                return cell
            }
        case .subscription:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRowCell.identifier) as! SettingsRowCell
            cell.selectionStyle = .none
            cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_inAppPurchase
            cell.switchButton.isHidden = true
            cell.imageviewNextArrow.isHidden = false
            cell.imageviewBottomLine.isHidden = true
            cell.labelSettingSubTitle.isHidden = true
            return cell
        case .connection:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRowCell.identifier) as! SettingsRowCell
            cell.selectionStyle = .none
            cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_blockedContacts
            cell.switchButton.isHidden = true
            cell.imageviewNextArrow.isHidden = false
            cell.imageviewBottomLine.isHidden = true
            cell.labelSettingSubTitle.isHidden = true
            return cell
        case .activeStatus:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRowCell.identifier) as! SettingsRowCell
            cell.selectionStyle = .none
            cell.switchButton.isHidden = false
            cell.switchButton.tag = indexPath.row
            cell.labelSettingSubTitle.isHidden = true
            cell.switchButton.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
            
            cell.imageviewNextArrow.isHidden = true
            switch enumActiveStatusRow(rawValue: indexPath.row)! {
            case .onlineNow:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_onlineNow
                cell.imageviewBottomLine.isHidden = false
                
                if viewModel.getIsOnline() == "1" {
                    cell.switchButton.setOn(true, animated: false)
                } else {
                    cell.switchButton.setOn(false, animated: false)
                }
                
            case .lastSeenStatus:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_lastSeenStatus
                cell.imageviewBottomLine.isHidden = true
                
                if viewModel.getIsLastSeen() == "1" {
                    cell.switchButton.setOn(true, animated: false)
                } else {
                    cell.switchButton.setOn(false, animated: false)
                }
            }
            return cell
        case .notification:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRowCell.identifier) as! SettingsRowCell
            cell.selectionStyle = .none
            cell.switchButton.isHidden = true
            cell.imageviewNextArrow.isHidden = false
            cell.labelSettingSubTitle.isHidden = true
            switch enumNotificationsRow(rawValue: indexPath.row)! {
            case .emailNotifications:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_emailNotifications
                cell.imageviewBottomLine.isHidden = false
            case .pushNotifications:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_pushNotifications
                cell.imageviewBottomLine.isHidden = true
            }
            return cell
        case .otherSettings:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRowCell.identifier) as! SettingsRowCell
            cell.selectionStyle = .none
            cell.switchButton.isHidden = true
            cell.imageviewNextArrow.isHidden = false
            switch enumOtherSettingsRow(rawValue: indexPath.row)! {
            case .restorePurchase:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_restorePurchase
                cell.imageviewBottomLine.isHidden = false
                cell.labelSettingSubTitle.isHidden = true
            case .inviteFriends:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_inviteFriends
                cell.imageviewBottomLine.isHidden = true
                cell.labelSettingSubTitle.isHidden = true
            }
            return cell
        case .contactUs:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRowCell.identifier) as! SettingsRowCell
            cell.selectionStyle = .none
            cell.labelSettingsRowTitle.text = Constants.labelSettingSectionTitle_contactUs
            cell.switchButton.isHidden = true
            cell.imageviewNextArrow.isHidden = false
            cell.imageviewBottomLine.isHidden = true
            cell.labelSettingSubTitle.isHidden = true
            return cell
        case .community:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRowCell.identifier) as! SettingsRowCell
            cell.selectionStyle = .none
            cell.switchButton.isHidden = true
            cell.imageviewNextArrow.isHidden = false
            cell.labelSettingSubTitle.isHidden = true
            switch enumCommunityRow(rawValue: indexPath.row)! {
            case .communityGuidelines:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_communityGuidelines
                cell.imageviewBottomLine.isHidden = false
            case .safetyTips:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_safetyTips
                cell.imageviewBottomLine.isHidden = false
            }
            return cell
        case .privacy:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRowCell.identifier) as! SettingsRowCell
            cell.selectionStyle = .none
            cell.switchButton.isHidden = true
            cell.imageviewNextArrow.isHidden = false
            cell.labelSettingSubTitle.isHidden = true
            switch enumPrivacyRow(rawValue: indexPath.row)! {
            case .cookiePolicy:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_cookiePolicy
                cell.imageviewBottomLine.isHidden = false
            case .privacyPolicy:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_privacyPolicy
                cell.imageviewBottomLine.isHidden = false
            }
            return cell
        case .legal:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRowCell.identifier) as! SettingsRowCell
            cell.selectionStyle = .none
            cell.switchButton.isHidden = true
            cell.imageviewNextArrow.isHidden = false
            cell.labelSettingSubTitle.isHidden = true
            switch enumLegalRow(rawValue: indexPath.row)! {
            case .termsOfService:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_termsOfService
                cell.imageviewBottomLine.isHidden = false
            case .licenses:
                cell.labelSettingsRowTitle.text = Constants.labelSettingRowTitle_licenses
                cell.imageviewBottomLine.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch enumSettingsTableSection(rawValue: indexPath.section)! {
        case .accountSetting:
            switch enumAccountSettingsRow(rawValue: indexPath.row)! {
            case .email:
                if Constants.loggedInUser?.connectedAccount![0].loginType == loginType.NORMAL {
                    let vc = UpdateEmailVC.loadFromNib()
                    viewController.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case .password:
                if Constants.loggedInUser?.connectedAccount![0].loginType == loginType.NORMAL {
                    let vc = ChangePasswordVC.loadFromNib()
                    viewController.navigationController?.pushViewController(vc, animated: true)
                }
                break
            }
        case .subscription:
            let subscriptionplanvc = SubscriptionPlanVC.loadFromNib()
            viewController.navigationController?.pushViewController(subscriptionplanvc, animated: true)
        case .connection:
            let vc = BlockedUserVC.loadFromNib()
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .activeStatus:
            break
        case .notification:
            switch enumNotificationsRow(rawValue: indexPath.row)! {
            case .emailNotifications:
                let vc = EmailNotification.loadFromNib()
                vc.is_from_push = 0
                viewController.navigationController?.pushViewController(vc, animated: true)
            case .pushNotifications:
                let vc = EmailNotification.loadFromNib()
                vc.is_from_push = 1
                viewController.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case .otherSettings:
            switch enumOtherSettingsRow(rawValue: indexPath.row)! {
            case .restorePurchase:
                IAPHelper.shared.restorePurchases()
            case .inviteFriends:
                inviteFriend()
            }
            break
        case .contactUs:
            let vc = WebviewVC.loadFromNib()
            vc.screenTitle = Constants.labelSettingSectionTitle_contactUs
            let languagename = getLanguage()
            if languagename == "en" {
                vc.url = URL(string: Constants.urlContactUsEn)
            } else if languagename == "fr" {
                vc.url = URL(string: Constants.urlContactUsFr)
            } else if languagename == "de" {
                vc.url = URL(string: Constants.urlContactUsDe)
            } else if languagename == "it" {
                vc.url = URL(string: Constants.urlContactUsIt)
            }
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .community:
            let vc = WebviewVC.loadFromNib()
            let languagename = getLanguage()
            switch enumCommunityRow(rawValue: indexPath.row)! {
            case .communityGuidelines:
                vc.screenTitle = Constants.labelSettingRowTitle_communityGuidelines
                if languagename == "en" {
                    vc.url = URL(string: Constants.urlCommunityGuideEn)
                } else if languagename == "fr" {
                    vc.url = URL(string: Constants.urlCommunityGuideFr)
                } else if languagename == "de" {
                    vc.url = URL(string: Constants.urlCommunityGuideDe)
                } else if languagename == "it" {
                    vc.url = URL(string: Constants.urlCommunityGuideIt)
                }
            case .safetyTips:
                vc.screenTitle = Constants.labelSettingRowTitle_safetyTips
                if languagename == "en" {
                    vc.url = URL(string: Constants.urlSafetyTipsEn)
                } else if languagename == "fr" {
                    vc.url = URL(string: Constants.urlSafetyTipsFr)
                } else if languagename == "de" {
                    vc.url = URL(string: Constants.urlSafetyTipsDe)
                } else if languagename == "it" {
                    vc.url = URL(string: Constants.urlSafetyTipsIt)
                }
            }
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .privacy:
            let vc = WebviewVC.loadFromNib()
            let languagename = getLanguage()
            switch enumPrivacyRow(rawValue: indexPath.row)! {
            case .cookiePolicy:
                vc.screenTitle = Constants.labelSettingRowTitle_cookiePolicy
                if languagename == "en" {
                    vc.url = URL(string: Constants.urlCookiePolicyEn)
                } else if languagename == "fr" {
                    vc.url = URL(string: Constants.urlCookiePolicyFr)
                } else if languagename == "de" {
                    vc.url = URL(string: Constants.urlCookiePolicyDe)
                } else if languagename == "it" {
                    vc.url = URL(string: Constants.urlCookiePolicyIt)
                }
            case .privacyPolicy:
                vc.screenTitle = Constants.labelSettingRowTitle_privacyPolicy
                if languagename == "en" {
                    vc.url = URL(string: Constants.urlPrivacyPolicyEn)
                } else if languagename == "fr" {
                    vc.url = URL(string: Constants.urlPrivacyPolicyFr)
                } else if languagename == "de" {
                    vc.url = URL(string: Constants.urlPrivacyPolicyDe)
                } else if languagename == "it" {
                    vc.url = URL(string: Constants.urlPrivacyPolicyIt)
                }
            }
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .legal:
            switch enumLegalRow(rawValue: indexPath.row)! {
            case .termsOfService:
                let vc = WebviewVC.loadFromNib()
                vc.screenTitle = Constants.labelSettingRowTitle_termsOfService
                let languagename = getLanguage()
                if languagename == "en" {
                    vc.url = URL(string: Constants.urlTermsConditionEn)
                } else if languagename == "fr" {
                    vc.url = URL(string: Constants.urlTermsConditionFr)
                } else if languagename == "de" {
                    vc.url = URL(string: Constants.urlTermsConditionDe)
                } else if languagename == "it" {
                    vc.url = URL(string: Constants.urlTermsConditionIt)
                }
                viewController.navigationController?.pushViewController(vc, animated: true)
                break
            case .licenses:
                let licensedetailsvc = LicenseDetailsVC.loadFromNib()
                viewController.navigationController?.pushViewController(licensedetailsvc, animated: true)
                break
            }
            break
        }
    }
    
    func inviteFriend() {
        if let name = URL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8"), !name.absoluteString.isEmpty {
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          viewController.present(activityVC, animated: true, completion: nil)
        } else {
            viewController.showAlertPopup(message: "Currently app not available.")
        }
    }
    
    func showLinkDetails(url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            viewController.present(vc, animated: true)
        }
    }
}
