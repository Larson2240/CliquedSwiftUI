//
//  UserConnectedVC.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit
import SDWebImage
import SocketIO

class MatchScreenVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var imageviewBackgroundScreen: UIImageView!
    @IBOutlet weak var buttonMessageNow: UIButton!
    @IBOutlet weak var viewbackgrounImg1: UIView!{
        didSet {
            viewbackgrounImg1.layer.cornerRadius = viewbackgrounImg1.frame.size.height / 2
            viewbackgrounImg1.layer.borderColor = Constants.color_themeColor.cgColor
            viewbackgrounImg1.layer.borderWidth = 2.0
        }
    }
    @IBOutlet weak var viewbackgrounImg2: UIView!{
        didSet {
            viewbackgrounImg2.layer.cornerRadius = viewbackgrounImg2.frame.size.height / 2
            viewbackgrounImg2.layer.borderColor = Constants.color_themeColor.cgColor
            viewbackgrounImg2.layer.borderWidth = 2.0
        }
    }
    @IBOutlet weak var buttonMessageLater: UIButton!
    @IBOutlet weak var imageviewUser1: UIImageView!{
        didSet {
            imageviewUser1.layer.cornerRadius = imageviewUser1.frame.size.height / 2
        }
    }
    @IBOutlet weak var imageviewUser2: UIImageView!{
        didSet {
            imageviewUser2.layer.cornerRadius = imageviewUser2.frame.size.height / 2
        }
    }
    @IBOutlet weak var labelMessage1: UILabel!{
        didSet {
            if isFromActivityScreen {
                labelMessage1.font = CustomFont.THEME_FONT_Bold(18)
            } else {
                labelMessage1.text = Constants.label_matchScreenText
                labelMessage1.font = CustomFont.THEME_FONT_Medium(15)
                labelMessage1.textColor = Constants.color_DarkGrey
            }
        }
    }
    
    @IBOutlet weak var labelMessage2: UILabel! {
        didSet {
            labelMessage2.text = Constants.label_matchScreenText
            labelMessage2.font = CustomFont.THEME_FONT_Medium(15)
            labelMessage2.textColor = Constants.color_DarkGrey
        }
    }
    
    //MARK: Variable
    var categoryName = ""
    var arrayOfFollowers = [Followers]()
    var isFromActivityScreen: Bool = false
    lazy var viewModel = MatchScreenViewModel()
    var isFromUserDetailsScreen: Bool = false
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()        
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APP_DELEGATE.socketIOHandler?.delegate = self
    }
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonMessageNow, buttonTitle: Constants.btn_messageNow)
        setupButtonUIWithGreyBackground(buttonName: buttonMessageLater, buttonTitle: Constants.btn_messageLater)
    }
    
    //MARK: Button Message Now Click
    @IBAction func btnMessageNowClick(_ sender: Any) {
        
        if arrayOfFollowers.count > 0 {
            
            let objFollower = arrayOfFollowers.first
            
//            if objFollower?.userId == Constants.loggedInUser?.id ?? 0 {
//                if objFollower?.receiverIsBlockedByAdmin == "1" {
//                    self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_admin_chat)
//                } else if objFollower?.receiverIsBlockedByUser == "1" {
//                    self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_user_chat)
//                } else {
//                    let dict:NSMutableDictionary = NSMutableDictionary()
//                    dict.setValue("\(objFollower?.counterUserId ?? 0)", forKey: "receiver_id")
//                    dict.setValue("\(objFollower?.userId ?? 0)", forKey: "user_id")
//                    APP_DELEGATE.socketIOHandler?.updateUserChatStatus(data: dict)
//                }
//            } else {
//                if objFollower?.senderIsBlockedByAdmin == "1" {
//                    self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_admin_chat)
//                } else if objFollower?.senderIsBlockedByUser == "1" {
//                    self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_user_chat)
//                } else {
//                    let dict:NSMutableDictionary = NSMutableDictionary()
//                    dict.setValue("\(objFollower?.userId ?? 0)", forKey: "receiver_id")
//                    dict.setValue("\(objFollower?.counterUserId ?? 0)", forKey: "user_id")
//                    APP_DELEGATE.socketIOHandler?.updateUserChatStatus(data: dict)
//                }
//            }
        }
    }
    
    //MARK: Button Message Later Click
    @IBAction func btnMessageLaterClick(_ sender: Any) {
        if isFromUserDetailsScreen {
            self.navigationController?.popToRootViewController(animated: true)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension MatchScreenVC : SocketIOHandlerDelegate {
   
    func connectionStatus(status: SocketIOStatus) {
        
    }
    
    func reloadConversation() {
       
    }
    
    func reloadUserChatStatus(sender_id:Int, receiver_id:Int,is_delete:String) {
        let strPredicate = NSString(format: "(senderId = %d AND receiverId = %d) OR (senderId = %d AND receiverId = %d)",sender_id,receiver_id,receiver_id,sender_id)
        
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
                let vc = MessageVC.loadFromNib()
//                vc.hidesBottomBarWhenPushed = true
//                vc.sender_id = Constants.loggedInUser?.id ?? 0
//
//                if "\(obj.senderId)" == "\(Constants.loggedInUser?.id ?? 0)" {
//                    vc.receiver_id = Int(obj.receiverId)
//                } else {
//                    vc.receiver_id = Int(obj.senderId)
//                }
                
//                vc.receiver_id = Int(obj.receiverId)
                vc.receiver_name = "\(obj.receiverName ?? "Cliqued User")"
                vc.receiver_profile = "\(obj.receiverProfile ?? "")"
                vc.receiver_last_seen = strLastSeen
                vc.receiver_is_online = "\(obj.isOnline ?? "")"
                vc.conversation_id = Int(obj.conversationId)
                vc.receiver_is_last_seen_enable = "\(obj.isLastSeenEnabled ?? "")"
                vc.recevier_chat_status = "\(obj.chatStatus ?? "")"
                vc.is_fromMatchScreen = true
                vc.is_blocked = obj.isBlockedByReceiver == "1" ? true : false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
           
            
        } else {
            
//            if arrayOfFollowers.count > 0 {
//
//                let objFollower = arrayOfFollowers.last
//
//                if objFollower?.userId == Constants.loggedInUser?.id ?? 0 {
//                    if objFollower?.receiverIsBlockedByAdmin == "1" {
//                        self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_admin_chat)
//                    } else if objFollower?.receiverIsBlockedByUser == "1" {
//                        self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_user_chat)
//                    } else {
//                        let vc = MessageVC.loadFromNib()
//                        vc.hidesBottomBarWhenPushed = true
//                        vc.sender_id = Constants.loggedInUser?.id ?? 0
//
//                        if "\(objFollower?.userId ?? 0)" == "\(Constants.loggedInUser?.id ?? 0)" {
//                            vc.receiver_id = (objFollower?.counterUserId!)!
//                            vc.receiver_profile = "\(objFollower?.receiverProfile ?? "")"
//                            vc.receiver_name = "\(objFollower?.receiverName ?? "")"
//                            vc.receiver_last_seen = "\(objFollower?.receiverLastSeen ?? "")"
//                            vc.receiver_is_online = "\(objFollower?.receiverIsOnline ?? "")"
//                            vc.receiver_is_last_seen_enable = "\(objFollower?.receiverIsLastSeenEnabled ?? "")"
//                            vc.recevier_chat_status = "\(objFollower?.receiverChatStatus ?? "")"
//                        } else {
//                            vc.receiver_id = (objFollower?.userId!)!
//                            vc.receiver_profile = "\(objFollower?.senderProfile ?? "")"
//                            vc.receiver_name = "\(objFollower?.senderName ?? "")"
//                            vc.receiver_last_seen = "\(objFollower?.senderLastSeen ?? "")"
//                            vc.receiver_is_online = "\(objFollower?.senderIsOnline ?? "")"
//                            vc.receiver_is_last_seen_enable = "\(objFollower?.senderIsLastSeenEnabled ?? "")"
//                            vc.recevier_chat_status = "\(objFollower?.senderChatStatus ?? "")"
//                        }
//
//                        vc.conversation_id = objFollower?.conversationId ?? 0
//                        vc.is_fromMatchScreen = true
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                } else {
//                    if objFollower?.senderIsBlockedByAdmin == "1" {
//                        self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_admin_chat)
//                    } else if objFollower?.senderIsBlockedByUser == "1" {
//                        self.showAlertPopup(message: Constants_Message.title_alert_for_block_by_user_chat)
//                    } else {
//                        let vc = MessageVC.loadFromNib()
//                        vc.hidesBottomBarWhenPushed = true
//
//                        if "\(objFollower?.userId ?? 0)" == "\(Constants.loggedInUser?.id ?? 0)" {
//                            vc.receiver_id = (objFollower?.counterUserId!)!
//                            vc.receiver_profile = "\(objFollower?.receiverProfile ?? "")"
//                            vc.receiver_name = "\(objFollower?.receiverName ?? "")"
//                            vc.receiver_last_seen = "\(objFollower?.receiverLastSeen ?? "")"
//                            vc.receiver_is_online = "\(objFollower?.receiverIsOnline ?? "")"
//                            vc.receiver_is_last_seen_enable = "\(objFollower?.receiverIsLastSeenEnabled ?? "")"
//                            vc.recevier_chat_status = "\(objFollower?.receiverChatStatus ?? "")"
//                        } else {
//                            vc.receiver_id = (objFollower?.userId!)!
//                            vc.receiver_profile = "\(objFollower?.senderProfile ?? "")"
//                            vc.receiver_name = "\(objFollower?.senderName ?? "")"
//                            vc.receiver_last_seen = "\(objFollower?.senderLastSeen ?? "")"
//                            vc.receiver_is_online = "\(objFollower?.senderIsOnline ?? "")"
//                            vc.receiver_is_last_seen_enable = "\(objFollower?.senderIsLastSeenEnabled ?? "")"
//                            vc.recevier_chat_status = "\(objFollower?.senderChatStatus ?? "")"
//                        }
//
//                        vc.sender_id = Constants.loggedInUser?.id ?? 0
//                        vc.conversation_id = objFollower?.conversationId ?? 0
//                        vc.is_fromMatchScreen = true
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
//            }
        }
    }
}


//MARK: Extension UDF
extension MatchScreenVC {
    
    func viewDidLoadMethod() {
        bindDataForScreen()
        setupUIForActivityMatchScreen()
        handleApiResponse()
    }
    //MARK: Managed UI
    func setupUIForActivityMatchScreen() {
        if isFromActivityScreen {
            self.imageviewBackgroundScreen.image = UIImage(named: "background_green")
            viewbackgrounImg1.layer.borderColor = Constants.color_GreenSelectedBkg.cgColor
            viewbackgrounImg2.layer.borderColor = Constants.color_GreenSelectedBkg.cgColor
            labelMessage1.isHidden = false
            labelMessage2.isHidden = false
        } else {
            self.imageviewBackgroundScreen.image = UIImage(named: "background")
            viewbackgrounImg1.layer.borderColor = Constants.color_themeColor.cgColor
            viewbackgrounImg2.layer.borderColor = Constants.color_themeColor.cgColor
            labelMessage1.isHidden = false
            labelMessage2.isHidden = true
        }
    }
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { message in
//            self.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { isSuccess in
            if isSuccess {
                
            }
        }
    }
    //MARK: Bind Data
    func bindDataForScreen() {
        let imageWidth = imageviewUser1.frame.size.width
        let imageHeight = imageviewUser1.frame.size.height
        
        if arrayOfFollowers.count > 0 {
            
            let objFollower = arrayOfFollowers.first
            
            //For send push notification and email
//            if objFollower?.counterUserId == Constants.loggedInUser?.id {
//                viewModel.setCounterUserId(value: "\(objFollower?.userId ?? 0)")
//            } else {
//                viewModel.setCounterUserId(value: "\(objFollower?.counterUserId ?? 0)")
//            }
            if isFromActivityScreen {
                viewModel.setIsActivity(value: "1")
            } else {
                viewModel.setIsActivity(value: "0")
            }
            viewModel.callSendPushNotificationAPI()
            //---------------------------------------
            
            //Setup sender image
            if let senderImg = objFollower?.senderProfile {
                let senderImgUrl = UrlProfileImage + senderImg
                let senderBaseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(senderImgUrl)"
                let senderUrl = URL(string: senderBaseTimbThumb)
                imageviewUser1.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imageviewUser1.sd_setImage(with: senderUrl, placeholderImage: UIImage(named: "placeholder_matchuser"), options: .refreshCached, context: nil)
            } else {
                imageviewUser1.image = UIImage(named: "placeholder_matchuser")
            }
            
            //Setup receiver image
            if let receiverImg = objFollower?.receiverProfile {
                let receiverImgUrl = UrlProfileImage + receiverImg
                let receiverBaseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(receiverImgUrl)"
                let receiverUrl = URL(string: receiverBaseTimbThumb)
                imageviewUser2.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imageviewUser2.sd_setImage(with: receiverUrl, placeholderImage: UIImage(named: "placeholder_matchuser"), options: .refreshCached, context: nil)
            }else {
                imageviewUser2.image = UIImage(named: "placeholder_matchuser")
            }
            
            
            if isFromActivityScreen {
                labelMessage1.isHidden = false
                labelMessage2.isHidden = false
                labelMessage1.text = "\(objFollower?.receiverName ?? "") \(Constants.label_activityMatchScreenTitle) \(self.categoryName)"
                labelMessage1.adjustsFontSizeToFitWidth = true
                labelMessage1.minimumScaleFactor = 0.5
            } else {
                self.imageviewBackgroundScreen.image = UIImage(named: "background")
                labelMessage1.isHidden = false
                labelMessage2.isHidden = true
            }
        }
    }
}
