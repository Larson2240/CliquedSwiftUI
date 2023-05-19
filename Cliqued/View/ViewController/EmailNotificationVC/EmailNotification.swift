//
//  EmailNotification.swift
//  Cliqued
//
//  Created by C100-132 on 17/02/23.
//

import UIKit

class EmailNotification: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var buttonUnsubscribe: UIButton!{
        didSet {
            buttonUnsubscribe.setTitle(Constants.btn_unsubscribe, for: .normal)
            buttonUnsubscribe.titleLabel?.font = CustomFont.THEME_FONT_Bold(18)
            buttonUnsubscribe.setTitleColor(Constants.color_white, for: .normal)
            buttonUnsubscribe.backgroundColor = Constants.color_themeColor
            buttonUnsubscribe.layer.cornerRadius = 24
        }
    }
    @IBOutlet weak var buttonSubscribe: UIButton!{
        didSet {
            buttonSubscribe.setTitle(Constants.btn_subscribe, for: .normal)
            buttonSubscribe.titleLabel?.font = CustomFont.THEME_FONT_Bold(18)
            buttonSubscribe.setTitleColor(Constants.color_white, for: .normal)
            buttonSubscribe.backgroundColor = Constants.color_themeColor
            buttonSubscribe.layer.cornerRadius = 24
        }
    }
    @IBOutlet var tableView: UITableView!
    
    //MARK: Variables
    var viewModel = EmailNotificationViewModel()
    var dataSource: EmailNotificationDataSource?
    var user_id = Constants.loggedInUser?.id ?? 0
    var is_from_push = 0

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
    
    //MARK: Button Subscribe Click
    @IBAction func btnSubscribeClick(_ sender: Any) {
        if is_from_push == 1 {
            setEnableOrDisableEmailNotification(isSubscribed: NotificationPermissionTypeIds.Yes)
        } else {
            setEnableOrDisableEmailNotification(isSubscribed: NotificationPermissionTypeIds.Yes)
        }
    }
    //MARK: Button Unsubscribe Click
    @IBAction func btnUnsubscribeClick(_ sender: Any) {
        if is_from_push == 1 {
            setEnableOrDisableEmailNotification(isSubscribed: NotificationPermissionTypeIds.No)
        } else {
            setEnableOrDisableEmailNotification(isSubscribed: NotificationPermissionTypeIds.No)
        }
    }
}

//MARK: Extension UDF
extension EmailNotification {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        
        dataSource = EmailNotificationDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        viewModel.setUserId(value: "\(user_id)")
        checkEmailNotificationPrefrenceHaveOrNot()
            
        // For Push Notification type 1 and Email notification type 0
        if is_from_push == 1 {
            if let array_records = Constants.getPreferenceData {
                
                let arr = array_records.filter({$0.typesOfPreference == PreferenceTypeIds.push_notification})
                
                viewModel.arrNotification = arr
            }
        } else {
            if let array_records = Constants.getPreferenceData {
                let arr = array_records.filter({$0.typesOfPreference == PreferenceTypeIds.email_notification})
                
                viewModel.arrNotification = arr
            }
        }
        tableView.reloadData()
        
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        if is_from_push == 1 {
            viewNavigationBar.labelNavigationTitle.text = Constants_Message.title_push_notification
        } else {
            viewNavigationBar.labelNavigationTitle.text = Constants_Message.title_email_notification
        }
        
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
        viewModel.isMessage.bind { message in
            self.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { isSuccess in
            if isSuccess {
                self.checkEmailNotificationPrefrenceHaveOrNot()
                self.tableView.reloadData()               
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
    //MARK: Check email or push notification preference data have or not in user preference
    func checkEmailNotificationPrefrenceHaveOrNot() {
        if let array = Constants.loggedInUser?.userPreferences,array.count > 0 {
            
            //Checked in user preference for email notification preference have or not
            if is_from_push == 1 {
                let is_pushVerificationArray = array.filter({$0.typesOfPreference == PreferenceTypeIds.push_notification})
            
                if is_pushVerificationArray.count > 0 {
                    let isSubscribed = is_pushVerificationArray.filter({$0.typesOfOptions == NotificationPermissionTypeIds.No})
                    
                    if isSubscribed.count > 0 {
                        self.buttonSubscribe.isHidden = false
                        self.buttonUnsubscribe.isHidden = true
                    } else {
                        
                        let arrInitialPush = array.filter({$0.typesOfPreference == PreferenceTypeIds.notification_enable})
                        
                        if arrInitialPush.count > 0 {
                            let arrInitialPushOption = arrInitialPush.filter({$0.typesOfOptions == PreferenceOptionIds.yes})
                            
                            if arrInitialPushOption.count > 0 {
                                self.buttonSubscribe.isHidden = true
                                self.buttonUnsubscribe.isHidden = false
                            } else {
                                self.buttonSubscribe.isHidden = true
                                self.buttonUnsubscribe.isHidden = true
                            }
                        } else {
                            self.buttonSubscribe.isHidden = true
                            self.buttonUnsubscribe.isHidden = true
                        }
                    }
                } else {
                    let arrInitialPush = array.filter({$0.typesOfPreference == PreferenceTypeIds.notification_enable})
                    
                    if arrInitialPush.count > 0 {
                        let arrInitialPushOption = arrInitialPush.filter({$0.typesOfOptions == PreferenceOptionIds.yes})
                        
                        if arrInitialPushOption.count > 0 {
                            self.buttonSubscribe.isHidden = true
                            self.buttonUnsubscribe.isHidden = false
                        } else {
                            self.buttonSubscribe.isHidden = true
                            self.buttonUnsubscribe.isHidden = true
                        }
                    } else {
                        self.buttonSubscribe.isHidden = true
                        self.buttonUnsubscribe.isHidden = true
                    }
                }
            } else {
                let is_emailVerificationArray = array.filter({$0.typesOfPreference == PreferenceTypeIds.email_notification})
            
                if is_emailVerificationArray.count > 0 {
                    let isSubscribed = is_emailVerificationArray.filter({$0.typesOfOptions == NotificationPermissionTypeIds.Yes})
                    
                    if isSubscribed.count > 0 {
                        if isSubscribed.count == 3 {
                            self.buttonSubscribe.isHidden = true
                            self.buttonUnsubscribe.isHidden = false
                        } else {
                            self.buttonSubscribe.isHidden = false
                            self.buttonUnsubscribe.isHidden = false
                        }
                    } else {
                        self.buttonSubscribe.isHidden = false
                        self.buttonUnsubscribe.isHidden = true
                    }
                } else {
                    self.buttonSubscribe.isHidden = true
                    self.buttonUnsubscribe.isHidden = false
                }
            }
            
        }
    }
    
    func setEnableOrDisableEmailNotification(isSubscribed: String) {
        var arrayPreferenceId = [String]()
        var arrayOptionId = [String]()
        
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfSubType = [SubTypes]()
        
        //Get email notification preference data from the master preference data
        if is_from_push == 1 {
            arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == PreferenceTypeIds.push_notification}) ?? []
            
            if arrayOfPreference.count > 0 {
                
                //Get Subtype array from the push notification preference array
                arrayOfSubType = arrayOfPreference[0].subTypes ?? []
                
                for i in 0..<arrayOfSubType.count {
                    
                    //Get id(preference Ids) from the subtype array
                    let preferenceId = arrayOfSubType[i].id
                    arrayPreferenceId.append("\(preferenceId ?? 0)")
                    
                    let typeOfPref = arrayOfSubType[i].typesOfPreference
                    
                    //Get Typeoption array from the subtype array
                    let arrayOfTypeOption = arrayOfSubType[i].typeOptions ?? []
                    
                    //Get Id of Yes option from all the typeoption object.
                    if typeOfPref == PreferenceTypeIds.new_matches {
                        let subTypesData = arrayOfTypeOption.filter({$0.typeOfOptions == isSubscribed})
                        let optId = subTypesData[0].id
                        arrayOptionId.append("\(optId ?? 0)")
                    } else if typeOfPref == PreferenceTypeIds.messages {
                        let subTypesData = arrayOfTypeOption.filter({$0.typeOfOptions == isSubscribed})
                        let optId = subTypesData[0].id
                        arrayOptionId.append("\(optId ?? 0)")
                    }
                }
            }
        } else {
            arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == PreferenceTypeIds.email_notification}) ?? []
            
            if arrayOfPreference.count > 0 {
                
                //Get Subtype array from the email notification preference array
                arrayOfSubType = arrayOfPreference[0].subTypes ?? []
                
                for i in 0..<arrayOfSubType.count {
                    
                    //Get id(preference Ids) from the subtype array
                    let preferenceId = arrayOfSubType[i].id
                    arrayPreferenceId.append("\(preferenceId ?? 0)")
                    
                    let typeOfPref = arrayOfSubType[i].typesOfPreference
                    
                    //Get Typeoption array from the subtype array
                    let arrayOfTypeOption = arrayOfSubType[i].typeOptions ?? []
                    
                    //Get Id of Yes option from all the typeoption object.
                    if typeOfPref == PreferenceTypeIds.new_matches {
                        let subTypesData = arrayOfTypeOption.filter({$0.typeOfOptions == isSubscribed})
                        let optId = subTypesData[0].id
                        arrayOptionId.append("\(optId ?? 0)")
                    } else if typeOfPref == PreferenceTypeIds.messages {
                        let subTypesData = arrayOfTypeOption.filter({$0.typeOfOptions == isSubscribed})
                        let optId = subTypesData[0].id
                        arrayOptionId.append("\(optId ?? 0)")
                    } else if typeOfPref == PreferenceTypeIds.promotions {
                        let subTypesData = arrayOfTypeOption.filter({$0.typeOfOptions == isSubscribed})
                        let optId = subTypesData[0].id
                        arrayOptionId.append("\(optId ?? 0)")
                    }
                }
            }
        }
        
        //Convert ids array to comma separated string
        let prferenceIds = arrayPreferenceId.map({String($0)}).joined(separator: ", ")
        let optionIds = arrayOptionId.map({String($0)}).joined(separator: ", ")
        
        viewModel.setPreferenceId(value: prferenceIds)
        viewModel.setPreferenceOptionId(value: optionIds)       
        viewModel.apiUpdateUserNotificationStatus()
    }
}

