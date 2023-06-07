//
//  MessageViewModel.swift
//  SwapItSports
//
//  Created by C100-132 on 25/05/22.
//

import Foundation
import UIKit

struct messageList {
    var msgDate = ""
    var msg = [CDMessage]()
}

class MessageViewModel {
    
    //    var arrMessages = [CDMessage]()
    var arrMessages = NSMutableArray()
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isMessageAdded: Dynamic<Bool> = Dynamic(false)
    var isUserDataGet: Dynamic<Bool> = Dynamic(false)
    private let apiParams = ApiParams()
    
    //MARK: Variables
    private struct structMessage {
        var sender_id = ""
        var receiver_id = ""
        var last_message_id = ""
        var receiver_name = ""
        var receiver_profile = ""
        var message_text = ""
        var message_type = ""
        var conversation_id = ""
        var media_type = ""
        var media_ids = ""
        var media_url = ""
        var unique_message_id = ""
        var chat_media = [Any]()
        var thumbnail_media = [UIImage]()
        var message_status = ""
        var user_call_id = "0"
        var parent_message_id = "0"
        var forwared_message_id = "0"
        var is_edited = "0"
        var call_status = "0"
        var host_by = "0"
        var call_duration = "0"
        var thumbnail_url = ""
        var is_online = ""
        var last_seen = ""
        var chat_status = ""
        var room_name = ""
        var access_token = ""
        var is_video = ""
    }
    
    private var structMessageValue = structMessage()
    var arrayOfMainUserList = [User]()
    
    //MARK: - API Call
    func callGetUserDetailsAPI(user_id: Int) {
        
        let params: NSDictionary = [
            apiParams.userID : user_id
        ]
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isLoaderShow.value = true
                self.arrayOfMainUserList.removeAll()
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetUserDetails, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                self.isLoaderShow.value = false
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        
                        if let userArray = json?["user"] as? NSArray {
                            if userArray.count > 0 {
                                let dicUser = userArray[0] as! NSDictionary
                                let decoder = JSONDecoder()
                                do {
                                    let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                    let objUser = try decoder.decode(User.self, from: jsonData)
                                    self.arrayOfMainUserList.append(objUser)
                                    self.isUserDataGet.value = true
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    } else {
                        self.isMessage.value = message ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    func apiAddChatMedia() {
        let params: NSDictionary = [
            apiParams.senderId: getSenderId(),
            apiParams.receiverId:getReceiverId(),
            apiParams.chatMedia: getChatMediaArray(),
            apiParams.thumbnail: getThumbnailMediaArray()
        ]
        
        print(params)
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                self?.isLoaderShow.value = true
            }
            
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.UploadChatMediaUrl, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoaderShow.value = false
                }
                
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        if let mediaIds = json?["media_ids"] as? NSArray, let mediaUrls = json?["media_url"] as? NSArray, let thumbnailUrls = json?["thumbnail_url"] as? NSArray, let arrMediaTypes = json?["media_types"] as? NSArray {
                            
                            self.sendMessageForMedia(arrMediaIds: mediaIds, arrMediaUrls: mediaUrls, arrthumbnailUrls: thumbnailUrls,arrMediaTypes: arrMediaTypes)
                        }
                    } else {
                        self.isMessage.value = message ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    func apiGetAccessToken() {
        let params: NSDictionary = [
            apiParams.userID: getSenderId(),
            apiParams.room_id:getRoomName(),
            apiParams.isVideo: getIsVideo()
        ]
        
        print(params)
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                self?.isLoaderShow.value = true
            }
            
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetTwilioAccessToken, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoaderShow.value = false
                }
                
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        if let strToken = json?["AccessToken"] as? String, !strToken.isEmpty {
                            self.setAccessToken(value: strToken)
                            self.isDataGet.value = true
                        }
                    } else {
                        self.isMessage.value = message ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    func apiCheckOtherUser() {
        let params: NSDictionary = [
            apiParams.userID: getSenderId(),
            apiParams.counterUserId : getReceiverId(),
            apiParams.room_id:getRoomName(),
            apiParams.isVideo: getIsVideo()
        ]
        
        print(params)
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                self?.isLoaderShow.value = true
            }
            
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.CheckCallStatusOfReceiver, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoaderShow.value = false
                }
                
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        if let strToken = json?["AccessToken"] as? String, !strToken.isEmpty {
                            self.setAccessToken(value: strToken)
                            self.isDataGet.value = true
                        }
                    } else {
                        self.isMessage.value = message ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    
    //MARK: - Socket Event
    func sendMessage() {
        
        let strPredicate = "(senderId = \(getSenderId()) and receiverId = \(getReceiverId())) or (senderId = \(getReceiverId()) and receiverId = \(getSenderId()))"
        
        let arrayList = CoreDataAdaptor.sharedDataAdaptor.fetchListWhere(predicate: NSPredicate (format: strPredicate as String))
        
        var conversationId = 0
        var is_blocked = 0
        
        if arrayList.count == 0 {
            let dictList = NSMutableDictionary()
            dictList.setValue(conversationId, forKey: "conversation_id")
            dictList.setValue(getSenderId(), forKey: "sender_id")
            dictList.setValue(getReceiverId(), forKey: "receiver_id")
            dictList.setValue(getReceiverName(), forKey: "receiver_name")
            dictList.setValue(getReceiverProfile(), forKey: "receiver_profile")
            
            dictList.setValue(getLastSeen(), forKey: "receiver_last_seen")
            dictList.setValue(getIsOnline(), forKey: "receiver_is_online")
            dictList.setValue(getChatStatus(), forKey: "receiver_chat_status")
            
            
            let arrayChat = NSMutableArray()
            arrayChat.add(dictList)
            
            _ = CoreDataAdaptor.sharedDataAdaptor.saveConversation(array: arrayChat)
        } else {
            let objList = arrayList.first
            let strId : Int64 = objList!.conversationId
            
            if objList?.isBlockByAdmin == "1" {
                is_blocked = 1
            } else if objList?.isBlockedBySender == "1" {
                is_blocked = 1
            } else if objList?.isBlockedByReceiver == "1" {
                is_blocked = 1
            } else {
                is_blocked = 0
            }
            conversationId = Int(strId)
        }
        
        setUniqueMessageId(value: randomString(length: 7))
        
        let dictMsg = NSMutableDictionary()
        dictMsg.setValue(0, forKey: "message_id")
        dictMsg.setValue(conversationId, forKey: "conversation_id")
        dictMsg.setValue(getUniqueMessageId(), forKey: "unique_message_id")
        dictMsg.setValue(getMessageText().toBase64(), forKey: "message_text")
        dictMsg.setValue(getSenderId(), forKey: "sender_id")
        dictMsg.setValue(getReceiverId(), forKey: "receiver_id")
        dictMsg.setValue(getMessageType(), forKey: "message_type")
        dictMsg.setValue(getMediaType(), forKey: "media_type")
        dictMsg.setValue(getMediaUrl(), forKey: "media_url")
        dictMsg.setValue(Date().localToUTC(format: "yyyy-MM-dd HH:mm:ss"), forKey: "created_date")
        dictMsg.setValue(Date().localToUTC(format: "yyyy-MM-dd HH:mm:ss"), forKey: "modified_date")
        dictMsg.setValue(getUserCallId(), forKey: "user_call_id")
        dictMsg.setValue(getParentMessageId(), forKey: "parent_message_id")
        dictMsg.setValue(getForwardedMessageId(), forKey: "forwared_message_id")
        dictMsg.setValue(getIsEdited(), forKey: "is_edited")
        dictMsg.setValue(getMessageStatus(), forKey: "message_status")
        dictMsg.setValue(getCallStatus(), forKey: "call_status")
        dictMsg.setValue(getHostBy(), forKey: "host_by")
        dictMsg.setValue(getCallDuration(), forKey: "call_duration")
        dictMsg.setValue(getThumbnailUrl(), forKey: "thumbnail_url")
        
        
        let arrayChat = NSMutableArray()
        arrayChat.add(dictMsg)
        
        _ = CoreDataAdaptor.sharedDataAdaptor.saveMessage(array: arrayChat)
        //        isMessageAdded.value = true
        
        let dict = NSMutableDictionary()
        dict.setValue(conversationId, forKey: "conversation_id")
        dict.setValue(getUniqueMessageId(), forKey: "unique_message_id")
        dict.setValue(getMessageText().toBase64(), forKey: "messageText")
        dict.setValue(getSenderId(), forKey: "sender_id")
        dict.setValue(getReceiverId(), forKey: "receiver_id")
        dict.setValue(getMessageType(), forKey: "message_type")
        dict.setValue(getMediaType(), forKey: "media_type")
        dict.setValue(getMediaIds(), forKey: "media_ids")
        dict.setValue("", forKey: "title")
        dict.setValue(getUserCallId(), forKey: "user_call_id")
        dict.setValue(getParentMessageId(), forKey: "parent_message_id")
        dict.setValue(getForwardedMessageId(), forKey: "forwarded_id")
        dict.setValue(getIsEdited(), forKey: "is_edited")
        dict.setValue(getMessageStatus(), forKey: "message_status")
        dict.setValue(getCallStatus(), forKey: "call_status")
        dict.setValue(getHostBy(), forKey: "host_by")
        dict.setValue(getCallDuration(), forKey: "call_duration")
        dict.setValue(getThumbnailUrl(), forKey: "thumbnail_url")
        dict.setValue("\(is_blocked)", forKey: "is_blocked")
        
        APP_DELEGATE.socketIOHandler?.sendMessage(data: dict)
        
        
    }
    
    func sendMessageForMedia(arrMediaIds: NSArray, arrMediaUrls: NSArray, arrthumbnailUrls: NSArray, arrMediaTypes: NSArray) {
        
        let strPredicate = "(senderId = \(getSenderId()) and receiverId = \(getReceiverId())) or (senderId = \(getReceiverId()) and receiverId = \(getSenderId()))"
        
        let arrayList = CoreDataAdaptor.sharedDataAdaptor.fetchListWhere(predicate: NSPredicate (format: strPredicate as String))
        
        var conversationId = 0
        var is_blocked = 0
        if arrayList.count == 0 {
            let dictList = NSMutableDictionary()
            dictList.setValue(conversationId, forKey: "conversation_id")
            dictList.setValue(getSenderId(), forKey: "sender_id")
            dictList.setValue(getReceiverId(), forKey: "receiver_id")
            dictList.setValue(getReceiverName(), forKey: "receiver_name")
            dictList.setValue(getReceiverProfile(), forKey: "receiver_profile")
            
            dictList.setValue(getLastSeen(), forKey: "receiver_last_seen")
            dictList.setValue(getIsOnline(), forKey: "receiver_is_online")
            dictList.setValue(getChatStatus(), forKey: "receiver_chat_status")
            
            
            let arrayChat = NSMutableArray()
            arrayChat.add(dictList)
            
            _ = CoreDataAdaptor.sharedDataAdaptor.saveConversation(array: arrayChat)
        } else {
            let objList = arrayList.first
            let strId : Int64 = objList!.conversationId
            conversationId = Int(strId)
            
            if objList?.isBlockByAdmin == "1" {
                is_blocked = 1
            } else if objList?.isBlockedBySender == "1" {
                is_blocked = 1
            } else if objList?.isBlockedByReceiver == "1" {
                is_blocked = 1
            } else {
                is_blocked = 0
            }
            
        }
        
        for i in 0..<arrMediaUrls.count {
            setUniqueMessageId(value: randomString(length: 7))
            
            let strType = "\(arrMediaTypes[i])"
            let messageType = Int(strType)! + 1
            let strMessageType = "\(messageType)"
            
            let dictMsg = NSMutableDictionary()
            dictMsg.setValue(0, forKey: "message_id")
            dictMsg.setValue(conversationId, forKey: "conversation_id")
            dictMsg.setValue(getUniqueMessageId(), forKey: "unique_message_id")
            dictMsg.setValue("", forKey: "message_text")
            dictMsg.setValue(getSenderId(), forKey: "sender_id")
            dictMsg.setValue(getReceiverId(), forKey: "receiver_id")
            dictMsg.setValue(strMessageType, forKey: "message_type")
            dictMsg.setValue(arrMediaTypes[i], forKey: "media_type")
            dictMsg.setValue(arrMediaUrls[i], forKey: "media_url")
            dictMsg.setValue(Date().localToUTC(format: "yyyy-MM-dd HH:mm:ss"), forKey: "created_date")
            dictMsg.setValue(Date().localToUTC(format: "yyyy-MM-dd HH:mm:ss"), forKey: "modified_date")
            dictMsg.setValue(getUserCallId(), forKey: "user_call_id")
            dictMsg.setValue(getParentMessageId(), forKey: "parent_message_id")
            dictMsg.setValue(getForwardedMessageId(), forKey: "forwared_message_id")
            dictMsg.setValue(getIsEdited(), forKey: "is_edited")
            dictMsg.setValue(getMessageStatus(), forKey: "message_status")
            dictMsg.setValue(getCallStatus(), forKey: "call_status")
            dictMsg.setValue(getHostBy(), forKey: "host_by")
            dictMsg.setValue(getCallDuration(), forKey: "call_duration")
            dictMsg.setValue(arrthumbnailUrls[i], forKey: "thumbnail_url")
            
            
            let arrayChat = NSMutableArray()
            arrayChat.add(dictMsg)
            
            _ = CoreDataAdaptor.sharedDataAdaptor.saveMessage(array: arrayChat)
            
            let dict = NSMutableDictionary()
            dict.setValue(conversationId, forKey: "conversation_id")
            dict.setValue(getUniqueMessageId(), forKey: "unique_message_id")
            dict.setValue("", forKey: "messageText")
            dict.setValue(getSenderId(), forKey: "sender_id")
            dict.setValue(getReceiverId(), forKey: "receiver_id")
            dict.setValue(strMessageType, forKey: "message_type")
            dict.setValue(arrMediaTypes[i], forKey: "media_type")
            dict.setValue("\(arrMediaIds[i])", forKey: "media_ids")
            dict.setValue("", forKey: "title")
            dict.setValue(0, forKey: "parent_message_id")
            dict.setValue(0, forKey: "forwarded_id")
            dict.setValue("0", forKey: "is_edited")
            dict.setValue(getUserCallId(), forKey: "user_call_id")
            dict.setValue(getParentMessageId(), forKey: "parent_message_id")
            dict.setValue(getForwardedMessageId(), forKey: "forwarded_id")
            dict.setValue(getIsEdited(), forKey: "is_edited")
            dict.setValue(getMessageStatus(), forKey: "message_status")
            dict.setValue(getCallStatus(), forKey: "call_status")
            dict.setValue(getHostBy(), forKey: "host_by")
            dict.setValue(getCallDuration(), forKey: "call_duration")
            dict.setValue(getThumbnailUrl(), forKey: "thumbnail_url")
            dict.setValue("\(is_blocked)", forKey: "is_blocked")
            
            APP_DELEGATE.socketIOHandler?.sendMessage(data: dict)
            
        }
        
        //        if arrMediaIds.count > 0 {
        //
        //            let strIds = arrMediaIds.componentsJoined(by: ",")
        //
        //            let dict = NSMutableDictionary()
        //            dict.setValue(conversationId, forKey: "conversation_id")
        //            dict.setValue(getUniqueMessageId(), forKey: "unique_message_id")
        //            dict.setValue("", forKey: "messageText")
        //            dict.setValue(getSenderId(), forKey: "sender_id")
        //            dict.setValue(getReceiverId(), forKey: "receiver_id")
        //            dict.setValue("\(enumMessageType.image.rawValue)", forKey: "message_type")
        //            dict.setValue("\(enumMediaType.image.rawValue)", forKey: "media_type")
        //            dict.setValue(strIds, forKey: "media_ids")
        //            dict.setValue(0, forKey: "parent_message_id")
        //            dict.setValue(0, forKey: "forwarded_id")
        //            dict.setValue("0", forKey: "is_edited")
        //
        //            APP_DELEGATE!.socketIOHandler?.sendMessage(data: dict)
        //        }
    }
    
}

extension MessageViewModel {
    
    // getter methods
    func getSenderId() -> String {
        return structMessageValue.sender_id
    }
    
    func getReceiverId() -> String {
        return structMessageValue.receiver_id
    }
    
    func getReceiverName() -> String {
        return structMessageValue.receiver_name
    }
    
    func getReceiverProfile() -> String {
        return structMessageValue.receiver_profile
    }
    
    func getMessageText() -> String {
        return structMessageValue.message_text
    }
    
    func getMessageType() -> String {
        return structMessageValue.message_type
    }
    
    func getLastMessageId() -> String {
        return structMessageValue.last_message_id
    }
    
    func getUniqueMessageId() -> String {
        return structMessageValue.unique_message_id
    }
    
    func getConversationId() -> String {
        return structMessageValue.conversation_id
    }
    
    func getMediaIds() -> String {
        return structMessageValue.media_ids
    }
    
    func getMediaUrl() -> String {
        return structMessageValue.media_url
    }
    
    func getMediaType() -> String {
        return structMessageValue.media_type
    }
    
    func getMessageStatus() -> String {
        return structMessageValue.message_status
    }
    
    func getUserCallId() -> String {
        structMessageValue.user_call_id
    }
    
    func getParentMessageId() -> String {
        structMessageValue.parent_message_id
    }
    
    func getForwardedMessageId() -> String {
        structMessageValue.forwared_message_id
    }
    
    func getIsEdited() -> String {
        structMessageValue.is_edited
    }
    
    func getCallStatus() -> String {
        structMessageValue.call_status
    }
    
    func getHostBy() -> String{
        structMessageValue.host_by
    }
    
    func getCallDuration() -> String {
        structMessageValue.call_duration
    }
    
    func getThumbnailUrl() -> String {
        structMessageValue.thumbnail_url
    }
    
    func getIsOnline() -> String {
        structMessageValue.is_online
    }
    
    func getLastSeen() -> String {
        structMessageValue.last_seen
    }
    
    func getChatStatus() -> String {
        structMessageValue.chat_status
    }
    
    func getRoomName() -> String {
        structMessageValue.room_name
    }
    
    func getAccessToken() -> String {
        structMessageValue.access_token
    }
    
    func getIsVideo() -> String {
        structMessageValue.is_video
    }
    
    //Setter Method
    func setSenderId(value:String) {
        structMessageValue.sender_id = value
    }
    
    func setReceiverId(value:String) {
        structMessageValue.receiver_id = value
    }
    
    func setReceiverName(value:String) {
        structMessageValue.receiver_name = value
    }
    
    func setReceiverProfile(value:String) {
        structMessageValue.receiver_profile = value
    }
    
    func setMessageText(value:String) {
        structMessageValue.message_text = value
    }
    
    func setMessageType(value:String) {
        structMessageValue.message_type = value
    }
    
    func setLastMessageId(value:String) {
        structMessageValue.last_message_id = value
    }
    
    func setUniqueMessageId(value:String) {
        structMessageValue.unique_message_id = value
    }
    
    func setConversationId(value:String) {
        structMessageValue.conversation_id = value
    }
    
    func setMediaIds(value:String) {
        structMessageValue.media_ids = value
    }
    
    func setMediaUrl(value:String) {
        structMessageValue.media_url = value
    }
    
    func setMediaType(value:String) {
        structMessageValue.media_type = value
    }
    
    func setMessageStatus(value:String) {
        structMessageValue.message_status = value
    }
    
    func setUserCallId(value:String) {
        structMessageValue.user_call_id = value
    }
    
    func setParentMessageId(value:String) {
        structMessageValue.parent_message_id = value
    }
    
    func setForwardedMessageId(value:String) {
        structMessageValue.forwared_message_id = value
    }
    
    func setIsEdited(value:String) {
        structMessageValue.is_edited = value
    }
    
    func setCallStatus(value:String) {
        structMessageValue.call_status = value
    }
    
    func setHostBy(value:String) {
        structMessageValue.host_by = value
    }
    
    func setCallDuration(value:String) {
        structMessageValue.call_duration = value
    }
    
    func setThumbnailUrl(value:String) {
        structMessageValue.thumbnail_url = value
    }
    
    func setIsOnline(value:String) {
        structMessageValue.is_online = value
    }
    
    func setLastSeen(value:String) {
        structMessageValue.last_seen = value
    }
    
    func setChatStatus(value:String)  {
        structMessageValue.chat_status = value
    }
    
    func setRoomName(value:String)  {
        structMessageValue.room_name = value
    }
    
    func setAccessToken(value:String)  {
        structMessageValue.access_token = value
    }
    
    func setIsVideo(value:String) {
        structMessageValue.is_video = value
    }
    
    //Media
    func setChatMedia(value: Any) {
        structMessageValue.chat_media.append(value)
    }
    
    func getChatMedia(at: Int) -> Any? {
        structMessageValue.chat_media[at]
    }
    
    func getChatMedia() -> Int {
        return structMessageValue.chat_media.count
    }
    
    func getChatMediaArray() -> [Any] {
        return structMessageValue.chat_media
    }
    
    func removeChatMedia(at: Int) {
        structMessageValue.chat_media.remove(at: at)
    }
    
    func removeAllChatMedia() {
        structMessageValue.chat_media.removeAll()
    }
    
    //MARK: - thumbnail media
    func setThumbnailMedia(value: UIImage) {
        structMessageValue.thumbnail_media.append(value)
    }
    
    func getThumbnailMedia(at: Int) -> UIImage? {
        structMessageValue.thumbnail_media[at]
    }
    
    func getThumbnailMedia() -> Int {
        return structMessageValue.thumbnail_media.count
    }
    
    func getThumbnailMediaArray() -> [UIImage] {
        return structMessageValue.thumbnail_media
    }
    
    func removeThumbnailMedia(at: Int) {
        structMessageValue.thumbnail_media.remove(at: at)
    }
    
    func removeAllThumbnailMedia() {
        structMessageValue.thumbnail_media.removeAll()
    }
}
