//
//  ChatVC.swift
//  Cliqued
//
//  Created by C211 on 11/01/23.
//

import UIKit
import SwiftUI
import SocketIO

class ChatVC: UIViewController {
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: UINavigationViewClass!
    @IBOutlet var viewCollection: UIView!
    @IBOutlet weak var imageviewLine: UIImageView!
    @IBOutlet weak var viewMessagesSection: UIView!
    
    @IBOutlet var labelNewMatchesTitle: UILabel! {
        didSet {
            labelNewMatchesTitle.text = Constants_Message.Chat_section_new_matches
            labelNewMatchesTitle.font = CustomFont.THEME_FONT_Bold(16)
            labelNewMatchesTitle.textColor = Constants.color_NavigationBarText
            
            labelNewMatchesTitle.lastLineFillPercent = 60
            labelNewMatchesTitle.linesCornerRadius = 10
            labelNewMatchesTitle.skeletonTextNumberOfLines = 1
            labelNewMatchesTitle.showAnimatedGradientSkeleton()
        }
    }
    
    @IBOutlet var collectionViewPeople: UICollectionView!
    
    @IBOutlet var tableViewMessage: UITableView!
    
    @IBOutlet var labelMessageSectionTitle: UILabel! {
        didSet {
            labelMessageSectionTitle.text = Constants_Message.Chat_section_messages
            labelMessageSectionTitle.font = CustomFont.THEME_FONT_Bold(16)
            labelMessageSectionTitle.textColor = Constants.color_NavigationBarText
            
            labelMessageSectionTitle.lastLineFillPercent = 60
            labelMessageSectionTitle.linesCornerRadius = 10
            labelMessageSectionTitle.skeletonTextNumberOfLines = 1
            labelMessageSectionTitle.showAnimatedGradientSkeleton()
        }
    }
    
    @IBOutlet var searchView: UIView! {
        didSet {
            searchView.layer.cornerRadius = searchView.frame.height / 2
            searchView.layer.masksToBounds = true
            searchView.showAnimatedGradientSkeleton()
        }
    }
    
    @IBOutlet var textFieldSearchChat: UITextField! {
        didSet {
            textFieldSearchChat.font = CustomFont.THEME_FONT_Book(13)
            textFieldSearchChat.textColor = Constants.color_message_time
            textFieldSearchChat.placeholder = Constants_Message.search_title
        }
    }
    
    @IBOutlet weak var viewProfileNotComplete: UIView!
    
    @IBOutlet weak var labelProfileMsg: UILabel!{
        didSet{
            labelProfileMsg.text = Constants.validMsg_profileIncompleteMsg
            labelProfileMsg.font = CustomFont.THEME_FONT_Medium(14)
            labelProfileMsg.textColor = Constants.color_DarkGrey
        }
    }
    
    @IBOutlet weak var buttonCompleteProfile: UIButton!
    
    @IBOutlet var labelNoDataFound: UILabel! {
        didSet{
            labelNoDataFound.text = Constants.label_noDataFound
            labelNoDataFound.font = CustomFont.THEME_FONT_Medium(14)
            labelNoDataFound.textColor = Constants.color_MediumGrey
        }
    }
    
    @IBOutlet var labelChatNoDataFound: UILabel! {
        didSet{
            labelChatNoDataFound.text = Constants_Message.title_chat_no_data_text
            labelChatNoDataFound.font = CustomFont.THEME_FONT_Medium(14)
            labelChatNoDataFound.textColor = Constants.color_MediumGrey
        }
    }
    
    @IBOutlet var matchViewHeightConstraint: NSLayoutConstraint!
    
    
    //MARK: Variable
    var dataSource : ChatDataSource?
    var viewModel = ChatViewModel()
    var user_id = "\(Constants.loggedInUser?.id ?? 0)"
    var strSearch = ""
    var selectedUser = -1
    var selectedSection = -1
    
    var favoriteActivity = [UserInterestedCategory]()
    var favoriteCategoryActivity = [UserInterestedCategory]()
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
        self.tabBarController?.tabBar.isHidden = false
        UIApplication.shared.applicationIconBadgeNumber = 0
        if isProfileCompleted() {
            strSearch = ""
            self.viewModel.setUserId(value: user_id)
            self.labelNoDataFound.isHidden = true
            APP_DELEGATE.socketIOHandler?.delegate = self
            
            self.viewModel.callUserLikesListAPI()
            
            self.viewModel.setSenderId(value: self.user_id)
            let dict = NSMutableDictionary()
            dict.setValue(self.viewModel.getSenderId(), forKey: "sender_id")
            APP_DELEGATE.socketIOHandler?.getConversation(data: dict)
            self.fetchFromLocal()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageReload(notification:)), name: .languageChange, object: nil)
    }
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonCompleteProfile, buttonTitle: Constants.btn_completeProfile)
    }
    
    @objc func languageReload(notification: NSNotification) {
        self.view.layoutIfNeeded()
    }
    
    //MARK: Button complete profile tap
    @IBAction func btnCompleteProfileTap(_ sender: Any) {
        manageSetupProfileNavigationFlow()
    }
    
    //MARK: - Fetch From Local
    func fetchFromLocal() {
        viewModel.arrConversation.removeAll()
        let sortDescriptor = NSSortDescriptor(key: "modifiedDate", ascending: false)
        let strPredicate = "(senderId = \(user_id) or receiverId = \(user_id))"
        viewModel.arrConversation = CoreDataAdaptor.sharedDataAdaptor.fetchListWhere(predicate: NSPredicate (format: strPredicate as String), sort: [sortDescriptor])
        
        if viewModel.arrConversation.count > 0 {
            labelMessageSectionTitle.hideSkeleton()
            tableViewMessage.isHidden = false
            tableViewMessage.reloadData()
            searchView.isHidden = false
            labelChatNoDataFound.isHidden = true
        } else {
            
            labelMessageSectionTitle.hideSkeleton()
            tableViewMessage.isHidden = true
            searchView.isHidden = true
            labelChatNoDataFound.isHidden = false
        }
    }
    
    func fetchFromLocalWithSearch() {
        viewModel.arrConversation.removeAll()
        let sortDescriptor = NSSortDescriptor(key: "modifiedDate", ascending: false)
        let strPredicate = "(senderId = \(user_id) or receiverId = \(user_id)) and receiverName contains[c] '\(strSearch)'"
        viewModel.arrConversation = CoreDataAdaptor.sharedDataAdaptor.fetchListWhere(predicate: NSPredicate (format: strPredicate as String), sort: [sortDescriptor])
        
        if viewModel.arrConversation.count > 0 {
            tableViewMessage.isHidden = false
            tableViewMessage.reloadData()
        } else {
            tableViewMessage.isHidden = true
        }
    }
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        if sender.text!.count > 0 {
            viewModel.arrConversation.removeAll()
            strSearch = sender.text!
            fetchFromLocalWithSearch()
        } else {
            strSearch = ""
            viewModel.arrConversation.removeAll()
            tableViewMessage.reloadData()
            fetchFromLocal()
        }
    }
    
    
    @IBAction func textfieldCancelAction(_ sender: UITextField) {
        self.view.endEditing(true)
        strSearch = ""
        viewModel.arrConversation.removeAll()
        tableViewMessage.reloadData()
        fetchFromLocal()
    }
}
//MARK: Extension UDF
extension ChatVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = ChatDataSource(collectionView: collectionViewPeople,tableView: tableViewMessage, viewModel: viewModel, viewController: self)
        collectionViewPeople.delegate = dataSource
        collectionViewPeople.dataSource = dataSource
        tableViewMessage.delegate = dataSource
        tableViewMessage.dataSource = dataSource
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_chat
        
        viewNavigationBar.buttonBack.isHidden = true
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
    }
    
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }
        
        viewModel.isUserDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                if UIApplication.getTopViewController() is ChatVC {
                    if self.viewModel.arrayOfMainUserList.count > 0 {
                        let activityuserdetailsvc = ActivityUserDetailsVC.loadFromNib()
                        activityuserdetailsvc.objUserDetails = self.viewModel.arrayOfMainUserList[0]
                        activityuserdetailsvc.hidesBottomBarWhenPushed = true
                        activityuserdetailsvc.is_fromChatActivity = true
                        self.navigationController?.pushViewController(activityuserdetailsvc, animated: true)
                    }
                }
            }
        }
        
        //If API success
        viewModel.isDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                self.labelNewMatchesTitle.hideSkeleton()
                if self.viewModel.arrUserMatchesList.count > 0 {
                    let arrList = self.viewModel.arrUserMatchesList
                    
                    let filteredSingleArray = arrList.filter({$0.counterUserId == Constants.loggedInUser?.id && $0.isMeetup == 0 && $0.isFollow == "1" && $0.counterUserFollowStatus == nil && ($0.blockStatus == nil || $0.blockStatus == "0")})
                    self.viewModel.arrSingleLikesList = filteredSingleArray
                    
                    let filteredArray = arrList.filter({$0.isMeetup == 1})
                    self.viewModel.arrMatchesList = filteredArray
                    self.labelNoDataFound.isHidden = true
                }
                self.collectionViewPeople.reloadData()
                
                if self.viewModel.arrConversation.count == 0 {
                    
                    if self.viewModel.arrUserMatchesList.count > 0 {
                        self.labelChatNoDataFound.text = Constants_Message.title_chat_no_data_text
                    } else {
                        self.labelChatNoDataFound.text = Constants.label_noDataFound
                    }
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
    
    //MARK: Function manage if user profile not complete
    func isProfileCompleted() -> Bool {
        if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
            self.viewProfileNotComplete.isHidden = true
            self.viewCollection.isHidden = false
            self.viewMessagesSection.isHidden = false
            self.imageviewLine.isHidden = false
            return true
        } else {
            bindUserDetailsData()
            self.viewCollection.isHidden = true
            self.viewMessagesSection.isHidden = true
            self.imageviewLine.isHidden = true
            self.viewProfileNotComplete.isHidden = false
            return false
        }
    }
    
    //MARK: Setup profile navigation flow
    func manageSetupProfileNavigationFlow() {
        let strCount: String?
        if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
            let profile_setup_count = Int((Constants.loggedInUser?.profileSetupType)!)!
            strCount = "\(profile_setup_count)"
        } else {
            let profile_setup_count = Int((Constants.loggedInUser?.profileSetupType)!)! + 1
            strCount = "\(profile_setup_count)"
        }
        switch strCount {
        case profileSetupType.name:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NameView())
            
        case profileSetupType.birthdate:
            APP_DELEGATE.window?.rootViewController =  UIHostingController(rootView: AgeView())
            
        case profileSetupType.gender:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: GenderView())
            
        case profileSetupType.relationship:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: RelationshipView(isFromEditProfile: false))
            
        case profileSetupType.category:
            let pickActivityView = PickActivityView(isFromEditProfile: false, arrayOfActivity: favoriteActivity)
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: pickActivityView)
            
        case profileSetupType.sub_category:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: PickSubActivityView(isFromEditProfile: false, categoryIds: "", arrayOfSubActivity: []))
            
        case profileSetupType.profile_images:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: SelectPicturesView(arrayOfProfileImage: [], isFromEditProfile: false))
            
        case profileSetupType.location:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: LocationView(isFromEditProfile: false, addressId: "", setlocationvc: "", objAddress: nil))
            
        case profileSetupType.notification_enable:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NotificationsView())
            
        case profileSetupType.completed:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView(selectionValue: 0))
        default:
            break
        }
    }
    
    //MARK: Bind data on screen from the user object.
    func bindUserDetailsData() {
        let userData = Constants.loggedInUser!
        
        if userData.userInterestedCategory?.count ?? 0 > 0 {
            if let interestedActivity = userData.userInterestedCategory {
                self.favoriteActivity = interestedActivity
            }
        }
        
        //MARK: Managed multiple same category object in one category object
        var arrayOfActivityIds = [Int]()
        if userData.userInterestedCategory?.count ?? 0 > 0 {
            for interestedCategoryData in userData.userInterestedCategory ?? [] {
                if let activityId = interestedCategoryData.activityId {
                    arrayOfActivityIds.append(activityId)
                }
            }
        }
        for activityId in arrayOfActivityIds {
            if let data = self.favoriteActivity.filter({$0.activityId == activityId}).first {
                if !self.favoriteActivity.contains(where: {$0.activityId == activityId}) {
                    self.favoriteCategoryActivity.append(data)
                }
            }
        }
    }
}

//MARK: Socket Events
extension ChatVC : SocketIOHandlerDelegate {
    func connectionStatus(status: SocketIOStatus) {
        if status == SocketIOStatus.connected {
            let dict = NSMutableDictionary()
            dict.setValue(self.viewModel.getSenderId(), forKey: "sender_id")
            APP_DELEGATE.socketIOHandler?.getConversation(data: dict)
        }
    }
    
    func reloadConversation() {
        viewModel.setIsConversationDataLoad(value: true)
        fetchFromLocal()
    }
    
    func reloadUserChatStatus(sender_id: Int, receiver_id: Int, is_delete: String) {
        let strPredicate = NSString(format: "(senderId = %d AND receiverId = %d) OR (senderId = %d AND receiverId = %d)", sender_id, receiver_id, receiver_id, sender_id)
        
        let arr = CoreDataAdaptor.sharedDataAdaptor.fetchListWhere(predicate: NSPredicate (format: strPredicate as String))
        
        if arr.count > 0 {
            let obj = arr[0]
            var strLastSeen = ""
            
            if obj.lastSeen != nil {
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let ldate = dateFormate.string(from: obj.lastSeen!)
                
                strLastSeen = ldate
            } else {
                strLastSeen = "0000-00-00 00:00:00"
            }
            
            if is_delete == "1" {
                self.showAlertPopup(message: Constants_Message.title_alert_for_deleted_user)
            } else if obj.isBlockByAdmin == "1" {
                self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_admin_chat)
            } else if obj.isBlockedBySender == "1" {
                self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_user_chat)
            } else {
                if UIApplication.getTopViewController() is ChatVC {
                    let vc = MessageVC.loadFromNib()
                    vc.hidesBottomBarWhenPushed = true
                    vc.sender_id = Int(user_id)!
                    
                    if "\(obj.senderId)" == user_id {
                        vc.receiver_id = Int(obj.receiverId)
                    } else {
                        vc.receiver_id = Int(obj.senderId)
                    }
                    vc.receiver_name = "\(obj.receiverName ?? "Cliqued User")"
                    vc.receiver_profile = "\(obj.receiverProfile ?? "")"
                    vc.receiver_last_seen = strLastSeen
                    vc.receiver_is_online = "\(obj.isOnline ?? "")"
                    vc.conversation_id = Int(obj.conversationId)
                    vc.receiver_is_last_seen_enable = "\(obj.isLastSeenEnabled ?? "")"
                    vc.recevier_chat_status = "\(obj.chatStatus ?? "")"
                    vc.is_blocked = obj.isBlockedByReceiver == "1" ? true : false
                    
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            
            if self.viewModel.arrMatchesList.count > 0 || self.viewModel.arrSingleLikesList.count > 0  {
                let obj = selectedSection == 0 ? self.viewModel.arrSingleLikesList[selectedUser] : self.viewModel.arrMatchesList[selectedUser]
                
                if obj.isBlockedByAdmin == "1" {
                    self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_admin_chat)
                } else if obj.isBlockedByUser == "1" {
                    self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_user_chat)
                } else {
                    if UIApplication.getTopViewController() is ChatVC {
                        let vc = MessageVC.loadFromNib()
                        vc.hidesBottomBarWhenPushed = true
                        vc.sender_id = Int(user_id)!
                        
                        if "\(obj.userId ?? 0)" == user_id {
                            vc.receiver_id = obj.counterUserId!
                        } else {
                            vc.receiver_id = obj.userId!
                        }
                        
                        vc.receiver_name = "\(obj.receiverName ?? "")"
                        vc.receiver_profile = "\(obj.receiverProfile ?? "")"
                        vc.receiver_last_seen = "\(obj.receiverLastSeen ?? "")"
                        vc.receiver_is_online = "\(obj.receiverIsOnline ?? "")"
                        vc.conversation_id = Int(obj.conversationId ?? 0)
                        vc.receiver_is_last_seen_enable = "\(obj.isLastSeenEnabled ?? "")"
                        vc.recevier_chat_status = "\(obj.chatStatus ?? "")"
                        
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}
