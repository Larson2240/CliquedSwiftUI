//
//  SocketIOHandler.swift
//  GoferDeliveryCustomer
//
//  Created by C100-104 on 03/03/20.
//  Copyright © 2020 C100-104. All rights reserved.
//

import Foundation
import SocketIO

@objc protocol SocketIOHandlerDelegate {
    func connectionStatus(status:SocketIOStatus)
    @objc optional func newMessage(array:[CDMessage])
    @objc optional func InitialMessage(array:[CDMessage])
    @objc optional func loadMoreMessage(array:[CDMessage])
    @objc optional func reloadMessages()
    @objc optional func reloadMessagesStatus()
    @objc optional func reloadConversation()
    @objc optional func reloadUserChatStatus(sender_id: Int, receiver_id: Int,is_delete:String)
    @objc optional func reloadUserstatus(user_id: String, onlineStatus: String, lastSeen:String)
}

class SocketIOHandler: NSObject {
    
   var delegate:SocketIOHandlerDelegate?
	   
   var manager: SocketManager?
   var socket: SocketIOClient?
   var isHandlerAdded:Bool = false
   var isJoinSocket:Bool = false
   var user_id = Constants.loggedInUser?.id ?? 0
    
    override init() {
        super.init()
        connectWithSocket()
    }
    
    //MARK:- ConnectWithSocket
	
    func connectWithSocket() {
        if manager==nil && socket == nil {
            manager = SocketManager(socketURL: URL(string: APIConstant.SOCKET_SERVER_PATH)!, config: [.log(true), .compress])
            socket = manager?.defaultSocket
            connectSocketWithStatus()
        }else if socket?.status == .connected {
            self.callFunctionsAfterConnection()
        }
    }
    
    func connectSocketWithStatus(){
        
        socket?.on(clientEvent: .connect) {data, ack in
            print("going for connect")
            print(data)
        }
        
        socket?.on(clientEvent: .statusChange) {data, ack in
            let val = data.first as! SocketIOStatus
            self.delegate?.connectionStatus(status: val)
            switch val {
            case .connected:
                self.callFunctionsAfterConnection()
                break
                
            default:
                break
            }
        }
        
        socket?.connect()
        print(socket?.status)
    }
    
    func callFunctionsAfterConnection()  {
        print("Connected")
         
        let dict:NSMutableDictionary = NSMutableDictionary()
        dict.setValue(Constants.loggedInUser?.id ?? 0, forKey: "user_id")
        joinSocketWithData(data: dict)
    }
    
    func background(){
        let dict:NSMutableDictionary = NSMutableDictionary()
        dict.setValue(Constants.loggedInUser?.id ?? 0, forKey: "user_id")
        self.socket?.emit(APIConstant.APISocketBackground, dict)
    }

    func foreground(){
        let dict:NSMutableDictionary = NSMutableDictionary()
        dict.setValue(Constants.loggedInUser?.id ?? 0, forKey: "user_id")
        self.socket?.emit(APIConstant.APISocketForeground, dict)

        let dict1:NSMutableDictionary = NSMutableDictionary()
        dict1.setValue("\(Constants.loggedInUser?.id ?? 0)", forKey: "receiver_id")
        dict1.setValue("0", forKey: "message_id")
        dict1.setValue("0", forKey: "sender_id")
        dict1.setValue("\(enumMessageStatus.delivered.rawValue)", forKey: "message_status")
        updateMessageStatus(data: dict1)
    }

    func disconnectSocket() {
      
        socket?.removeAllHandlers()
        socket?.disconnect()
        manager?.removeSocket(socket!)
    }
    
	//MARK:- Join Socket With User
	  func joinSocketWithData(data:NSDictionary) {
		 
       
        socket?.emit(APIConstant.APISocketJoin_Socket, data)
        isJoinSocket = true
          
          let dict1:NSMutableDictionary = NSMutableDictionary()
          dict1.setValue("\(Constants.loggedInUser?.id ?? 0)", forKey: "receiver_id")
          dict1.setValue("0", forKey: "message_id")
          dict1.setValue("0", forKey: "sender_id")
          dict1.setValue("\(enumMessageStatus.delivered.rawValue)", forKey: "message_status")
          updateMessageStatus(data: dict1)
          
            AddHandlers()
	  }
    
	//MARK:- Add Handlers
	func AddHandlers()
	{
       
        socket?.on(APIConstant.APIBlockedInChat) {data, ack in
            print(data)
            
            if ((data[0] as! NSDictionary).value(forKey: "status")) as! Int == 1 {
                if let topVC = UIApplication.getTopViewController(), topVC.isKind(of: MessageVC.self) {
                        topVC.navigationController?.popViewController(animated: true)
                }
            }
        }        
        
        socket?.on(APIConstant.APIUserSecurityToken) {data, ack in
            print(data)
            if let strUserId = ((data[0] as! NSDictionary).value(forKey: "user_id")) as? Int {
                
                let dic:NSDictionary = (data[0] as! NSDictionary)
                print(dic)
                let arrMessage = dic.value(forKey: "userList") as! NSMutableArray
                
                if let topVC = UIApplication.getTopViewController(), topVC.isKind(of: MessageVC.self) {
                    
                    if strUserId == Constants.loggedInUser?.id {
                        if let appToken = userDefaults.value(forKey: kAppToken) as? String {
                         
                            for i in 0..<arrMessage.count {
                                let dictMessage = arrMessage[i] as! NSMutableDictionary
                                
                                if appToken != dictMessage.value(forKey: "token") as! String {
                                    topVC.showAlerBox("", Constants_Message.title_login_detected) { _ in
                                        clearUserDefaultWithSocket()
                                        APP_DELEGATE.setRegisterOptionRootViewController()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        socket?.on(APIConstant.APISocketUserConnectionChanged) {data, ack in
            print(data)
            
            if let strUserId = ((data[0] as! NSDictionary).value(forKey: "user_id")) as? Int {
                let is_online = ((data[0] as! NSDictionary).value(forKey: "isOnline")) as? Int
                let last_seen = ((data[0] as! NSDictionary).value(forKey: "last_seen_date")) as? String
                
                let updateStatusFlag = CoreDataAdaptor.sharedDataAdaptor.updateUserStatus(receiverId: "\(strUserId)", receiverChatStatus: "\(is_online!)", lastseen: "\(last_seen!)")
                
                self.delegate?.reloadUserstatus?(user_id: "\(strUserId)", onlineStatus: "\(is_online ?? 0)", lastSeen: "\(last_seen ?? "0000-00-00 00:00:00")")
            }
        }
        
        socket?.on(APIConstant.APISOCKETUpdateMessageStatusToSender) {data, ack in
            
            print(data)
            
            if ((data[0] as! NSDictionary).value(forKey: "status")) as! Int == 1 {
                
                let dic:NSDictionary = (data[0] as! NSDictionary)
                print(dic)
               
                let dictMessage = dic.value(forKey: "recipients") as! NSMutableDictionary
                
                let msgId = dictMessage.value(forKey: "message_id")
                let msgText = dictMessage.value(forKey: "message_text")
                let msgType = dictMessage.value(forKey: "message_type")
                let mediaId = dictMessage.value(forKey: "media_id")
                let uniqueId = dictMessage.value(forKey: "unique_message_id")
                let conversationId = dictMessage.value(forKey: "conversation_id")
                let senderId = "\(dictMessage.value(forKey: "sender_id") ?? "0")"
                let receiverId = dictMessage.value(forKey: "receiver_id")
                let modifiedDate = dictMessage.value(forKey: "modified_date")
                                
                var receiverName = ""
                var receiver_profile = ""
                var receiver_last_seen = ""
                var receiver_is_online = ""
                var receiver_chat_status = ""
                var is_last_seen_enable = ""
                var is_blocked_by_admin = ""
                var is_blocked_by_user = ""
                var is_blocked_by_receiver = ""
                
                if self.user_id == Int(senderId) {
                    receiverName = dictMessage.value(forKey: "receiver_name") as! String
                    receiver_profile = "\(dictMessage.value(forKey: "receiver_profile") ?? "")"
                    receiver_last_seen = dictMessage.value(forKey: "receiver_last_seen") as! String
                    receiver_is_online = "\(dictMessage.value(forKey: "receiver_is_online") ?? "")"
                    receiver_chat_status = "\(dictMessage.value(forKey: "receiver_chat_status") ?? "")"
                    
                    is_last_seen_enable = "\(dictMessage.value(forKey: "receiver_is_last_seen_enable") ?? "")"
                    is_blocked_by_admin = "\(dictMessage.value(forKey: "receiver_is_blocked_admin") ?? "")"
                    is_blocked_by_user = "\(dictMessage.value(forKey: "receiver_blocked_in_app") ?? "")"
                    is_blocked_by_receiver = "\(dictMessage.value(forKey: "sender_blocked_in_app") ?? "")"
                } else {
                    receiverName = dictMessage.value(forKey: "sender_name") as! String
                    receiver_profile = "\(dictMessage.value(forKey: "sender_profile") ?? "")"
                    receiver_last_seen = dictMessage.value(forKey: "sender_last_seen") as! String
                    receiver_is_online = "\(dictMessage.value(forKey: "sender_is_online") ?? "")"
                    receiver_chat_status = "\(dictMessage.value(forKey: "sender_chat_status") ?? "")"
                    
                    is_last_seen_enable = "\(dictMessage.value(forKey: "sender_is_last_seen_enable") ?? "")"
                    is_blocked_by_admin = "\(dictMessage.value(forKey: "sender_is_blocked_admin") ?? "")"
                    is_blocked_by_user = "\(dictMessage.value(forKey: "sender_blocked_in_app") ?? "")"
                    is_blocked_by_receiver = "\(dictMessage.value(forKey: "receiver_blocked_in_app") ?? "")"
                }
                
                
                let userCallId = dictMessage.value(forKey: "user_call_id")
                let parentMessageId = dictMessage.value(forKey: "parent_message_id")
                let forwardedMessageId = dictMessage.value(forKey: "forwared_message_id")
                let isEdited = dictMessage.value(forKey: "is_edited")
                let messageStatus = dictMessage.value(forKey: "message_status")
                let callStatus = dictMessage.value(forKey: "call_status")
                let host_by = dictMessage.value(forKey: "host_by")
                let callduration = dictMessage.value(forKey: "call_duration")
                let thumbnailUrl = dictMessage.value(forKey: "thumbnail_url")
                
                let updateConFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversation(conversationId: "\(conversationId!)", senderId: "\(senderId)", receiverId: "\(receiverId!)", receiverName: "\(receiverName)", receiverProfile: "\(receiver_profile)", lastDate: "\(modifiedDate!)",messageText: "\(msgText!)",messageType:"\(msgType!)")
                
                let updateConStatusFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversationChatStatus(conversationId: "\(conversationId!)", senderId: "\(senderId)", receiverId: "\(receiverId!)", receiverIsOnline: "\(receiver_is_online)", receiverChatStatus: "\(receiver_chat_status)", lastseen: "\(receiver_last_seen)",isLastEnable: "\(is_last_seen_enable)",isBlockedByAdmin:"\(is_blocked_by_admin)",isBlockedByUser:"\(is_blocked_by_user)",isBlockedByReceiver: "\(is_blocked_by_receiver)")
                
                
                if (CoreDataAdaptor.sharedDataAdaptor.updateMessageID(messageID: "\(msgId!)", conversationId: "\(conversationId!)", mediaId: "\(mediaId!)", createdDate: dictMessage.value(forKey: "created_date") as! String, modifiedDate: dictMessage.value(forKey: "modified_date") as! String, uniqueId: "\(uniqueId!)", userCallId: "\(userCallId!)", parentMessageId: "\(parentMessageId!)", forwardedMessageId: "\(forwardedMessageId!)", isEdited: "\(isEdited!)", messageStatus: "\(messageStatus!)", callStatus: "\(callStatus!)", host_by: "\(host_by!)", callduration: "\(callduration!)", thumbnailUrl: "\(thumbnailUrl!)")) {
                    
                    self.delegate?.reloadMessagesStatus?()
                }                
            }
        }
        
        socket?.on(APIConstant.APISOCKETGetNewMessage) {data, ack in
           
            if ((data[0] as! NSDictionary).value(forKey: "status")) as! Int == 1 {
               
                let dic:NSDictionary = (data[0] as! NSDictionary)
               
                let arrMessage = dic.value(forKey: "Conversation") as! NSMutableArray
                let dictMessage = arrMessage[0] as! NSMutableDictionary
                
                let conversationId = "\(dictMessage.value(forKey: "conversation_id") ?? "0")"
                let senderId = "\(dictMessage.value(forKey: "sender_id") ?? "0")"
                let receiverId = "\(dictMessage.value(forKey: "receiver_id") ?? "0")"
                let messageId = "\(dictMessage.value(forKey: "message_id") ?? "0")"
                let mediaId = "\(dictMessage.value(forKey: "media_id") ?? "0")"
                               
                let msgText = dictMessage.value(forKey: "message_text")
                let msgType = dictMessage.value(forKey: "message_type")
                
                var receiverName = ""
                var receiver_profile = ""
                var receiver_last_seen = ""
                var receiver_is_online = ""
                var receiver_chat_status = ""
                var is_last_seen_enable = ""
                var is_blocked_by_admin = ""
                var is_blocked_by_user = ""
                var is_blocked_by_receiver = ""
                                            
                if self.user_id == Int(senderId) {
                    receiverName = dictMessage.value(forKey: "receiver_name") as! String
                    receiver_profile = "\(dictMessage.value(forKey: "receiver_profile") ?? "")"
                    receiver_last_seen = dictMessage.value(forKey: "receiver_last_seen") as! String
                    receiver_is_online = "\(dictMessage.value(forKey: "receiver_is_online") ?? "")"
                    receiver_chat_status = "\(dictMessage.value(forKey: "receiver_chat_status") ?? "")"
                    
                    is_last_seen_enable = "\(dictMessage.value(forKey: "receiver_is_last_seen_enable") ?? "")"
                    is_blocked_by_admin = "\(dictMessage.value(forKey: "receiver_is_blocked_admin") ?? "")"
                    is_blocked_by_user = "\(dictMessage.value(forKey: "receiver_blocked_in_app") ?? "")"
                    is_blocked_by_receiver = "\(dictMessage.value(forKey: "sender_blocked_in_app") ?? "")"
                } else {
                    receiverName = dictMessage.value(forKey: "sender_name") as! String
                    receiver_profile = "\(dictMessage.value(forKey: "sender_profile") ?? "")"
                    receiver_last_seen = dictMessage.value(forKey: "sender_last_seen") as! String
                    receiver_is_online = "\(dictMessage.value(forKey: "sender_is_online") ?? "")"
                    receiver_chat_status = "\(dictMessage.value(forKey: "sender_chat_status") ?? "")"
                    
                    is_last_seen_enable = "\(dictMessage.value(forKey: "sender_is_last_seen_enable") ?? "")"
                    is_blocked_by_admin = "\(dictMessage.value(forKey: "sender_is_blocked_admin") ?? "")"
                    is_blocked_by_user = "\(dictMessage.value(forKey: "sender_blocked_in_app") ?? "")"
                    is_blocked_by_receiver = "\(dictMessage.value(forKey: "receiver_blocked_in_app") ?? "")"
                }
                          
                let strPredicate = "(senderId = \(senderId) and receiverId = \(receiverId)) or (senderId = \(receiverId) and receiverId = \(senderId))"
                
                let arrayList = CoreDataAdaptor.sharedDataAdaptor.fetchListWhere(predicate: NSPredicate (format: strPredicate as String))
                
                if arrayList.count == 0 {
                    let dictList = NSMutableDictionary()
                    dictList.setValue(conversationId, forKey: "conversation_id")
                                       
                    if self.user_id == Int(senderId) {
                        dictList.setValue(senderId, forKey: "sender_id")
                        dictList.setValue(receiverId, forKey: "receiver_id")
                        dictList.setValue(is_last_seen_enable, forKey: "is_last_seen_enable")
                        dictList.setValue(is_blocked_by_admin, forKey: "is_blocked_by_admin")
                        dictList.setValue(is_blocked_by_user, forKey: "is_blocked_by_user")
                        dictList.setValue(is_blocked_by_receiver, forKey: "is_blocked_by_receiver")
                    } else {
                        dictList.setValue(receiverId, forKey: "sender_id")
                        dictList.setValue(senderId, forKey: "receiver_id")
                        dictList.setValue(is_last_seen_enable, forKey: "is_last_seen_enable")
                        dictList.setValue(is_blocked_by_admin, forKey: "is_blocked_by_admin")
                        dictList.setValue(is_blocked_by_user, forKey: "is_blocked_by_user")
                        dictList.setValue(is_blocked_by_receiver, forKey: "is_blocked_by_receiver")
                    }
                     
                    
                    dictList.setValue(senderId, forKey: "sender_id")
                    dictList.setValue(receiverId, forKey: "receiver_id")
                    
                    dictList.setValue(receiverName, forKey: "receiver_name")
                    dictList.setValue(receiver_profile, forKey: "receiver_profile")
                    
                    dictList.setValue(receiver_last_seen, forKey: "receiver_last_seen")
                    dictList.setValue(receiver_is_online, forKey: "receiver_is_online")
                    dictList.setValue(receiver_chat_status, forKey: "receiver_chat_status")
                    
                    dictList.setValue("\(dictMessage.value(forKey: "created_date") ?? "")", forKey: "created_date")
                    dictList.setValue("\(dictMessage.value(forKey: "modified_date") ?? "")", forKey: "modified_date")
                    
                    dictList.setValue("\(dictMessage.value(forKey: "message_text") ?? "")", forKey: "message_text")
                    dictList.setValue("\(dictMessage.value(forKey: "message_type") ?? "")", forKey: "message_type")
                    
                    let arrayChat = NSMutableArray()
                    arrayChat.add(dictList)
                    
                    _ = CoreDataAdaptor.sharedDataAdaptor.saveConversation(array: arrayChat)
                    
                    self.delegate?.reloadConversation?()
                } else {
                    
                    let updateConFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversation(conversationId: "\(conversationId)", senderId: "\(senderId)", receiverId: "\(receiverId)", receiverName: "\(receiverName)", receiverProfile: "\(receiver_profile)", lastDate: "\(dictMessage.value(forKey: "modified_date") ?? "")",messageText: "\(msgText!)",messageType:"\(msgType!)")
                    
                    let updateConStatusFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversationChatStatus(conversationId: "\(conversationId)", senderId: "\(senderId)", receiverId: "\(receiverId)", receiverIsOnline: "\(receiver_is_online)", receiverChatStatus: "\(receiver_chat_status)", lastseen: "\(receiver_last_seen)",isLastEnable: "\(is_last_seen_enable)",isBlockedByAdmin:"\(is_blocked_by_admin)",isBlockedByUser:"\(is_blocked_by_user)",isBlockedByReceiver: "\(is_blocked_by_receiver)")
                    
                    self.delegate?.reloadConversation?()
                    
                }
                
                let dictMsg = NSMutableDictionary()
                dictMsg.setValue(messageId, forKey: "message_id")
                dictMsg.setValue(conversationId, forKey: "conversation_id")
                dictMsg.setValue(senderId, forKey: "sender_id")
                dictMsg.setValue(receiverId, forKey: "receiver_id")
                dictMsg.setValue(mediaId, forKey: "media_id")
                dictMsg.setValue(dictMessage.value(forKey: "unique_message_id") as! String, forKey: "unique_message_id")
                dictMsg.setValue("\(dictMessage.value(forKey: "message_text") ?? "")", forKey: "message_text")
                dictMsg.setValue("\(dictMessage.value(forKey: "message_type") ?? "")", forKey: "message_type")
                dictMsg.setValue("\(dictMessage.value(forKey: "url") ?? "")", forKey: "media_url")
                dictMsg.setValue(dictMessage.value(forKey: "created_date") as! String, forKey: "created_date")
                dictMsg.setValue(dictMessage.value(forKey: "modified_date") as! String, forKey: "modified_date")
                
                dictMsg.setValue("\(dictMessage.value(forKey: "user_call_id") ?? "")", forKey: "user_call_id")
                dictMsg.setValue("\(dictMessage.value(forKey: "parent_message_id") ?? "")", forKey: "parent_message_id")
                dictMsg.setValue("\(dictMessage.value(forKey: "forwared_message_id") ?? "")", forKey: "forwared_message_id")
                dictMsg.setValue("\(dictMessage.value(forKey: "is_edited") ?? "")", forKey: "is_edited")
                
                dictMsg.setValue("\(dictMessage.value(forKey: "message_status") ?? "")", forKey: "message_status")
                dictMsg.setValue("\(dictMessage.value(forKey: "call_status") ?? "")", forKey: "call_status")
                dictMsg.setValue("\(dictMessage.value(forKey: "host_by") ?? "")", forKey: "host_by")
                dictMsg.setValue("\(dictMessage.value(forKey: "call_duration") ?? "")", forKey: "call_duration")
                dictMsg.setValue("\(dictMessage.value(forKey: "thumbnail_url") ?? "")", forKey: "thumbnail_url")
               
                let arrayChat = NSMutableArray()
                arrayChat.add(dictMsg)
                
               let arrayObjMessage = CoreDataAdaptor.sharedDataAdaptor.saveMessage(array: arrayChat)
                if arrayObjMessage.count != 0 {
                    
                    let dict:NSMutableDictionary = NSMutableDictionary()
                    dict.setValue(receiverId, forKey: "receiver_id")
                    dict.setValue(messageId, forKey: "message_id")
                    dict.setValue(senderId, forKey: "sender_id")
                    dict.setValue("\(enumMessageStatus.delivered.rawValue)", forKey: "message_status")
                    self.updateMessageStatus(data: dict)
                    
                    self.delegate?.InitialMessage?(array: arrayObjMessage)
              }  else {
                  
                  let dict:NSMutableDictionary = NSMutableDictionary()
                  dict.setValue(receiverId, forKey: "receiver_id")
                  dict.setValue(messageId, forKey: "message_id")
                  dict.setValue(senderId, forKey: "sender_id")
                  dict.setValue("\(enumMessageStatus.delivered.rawValue)", forKey: "message_status")
                  self.updateMessageStatus(data: dict)
                  
                  self.delegate?.reloadMessages?()
              }
            }
        }
        
        socket?.on(APIConstant.APISockerCall_Init_Receivers, callback: { data, ack in
                      
            
            if let dic = data[0] as? NSDictionary {
                Calling.room_sid = dic["room_sid"] as? String ?? ""
                Calling.room_Name = dic["room_name"] as? String ?? ""
                Calling.sender_access_token = dic["sender_access_token"] as? String ?? ""
                Calling.call_id = dic["call_id"] as? String ?? ""
                Calling.is_privateRoom = dic["private_room"] as? String ?? ""
                Calling.is_host = dic["is_host"] as? String ?? ""
            }
        })
        
        socket?.on(APIConstant.APICallDismissBySender, callback: { data, ack in
            print(data)
                        
            APP_DELEGATE.providerDelegate.RejectSessionSub(callStatus: enumCallStatus.rejected.rawValue)
        })
        
        socket?.on(APIConstant.APICallStatusUpdate, callback: { data, ack in
                        
            if let dicMain = data[0] as? NSDictionary {
                if let dic = dicMain["Conversation"] as? NSDictionary {
                    let userCount = dicMain["user_count"] as? Int ?? -1
                    let status = dic["call_status"] as? String ?? ""
                    let isHost = dic["is_host"] as? String ?? ""
                    
                    Calling.room_sid = dic["room_sid"] as? String ?? ""
                    Calling.room_Name = dic["room_name"] as? String ?? ""
                    Calling.sender_access_token = dic["sender_access_token"] as? String ?? ""
                    Calling.call_id = dic["call_id"] as? String ?? ""
                    Calling.is_privateRoom = dic["private_room"] as? String ?? ""
                    
                    Calling.call_start_time = dic["call_start_time"] as? String ?? ""
                    Calling.call_status = dic["call_status"] as? String ?? ""
                    Calling.user_count = dicMain["user_count"] as? Int ?? -1
                    
                    if (dic["private_room"] as? String ?? "") == "0" {
                        
                        if (status == enumCallStatus.received.rawValue) || (status == enumCallStatus.calling.rawValue) {
                            Calling.receiver_name = dic["user_name"] as? String ?? ""
                            NotificationCenter.default.post(name: .updateName, object:nil)
                        }
                        
                        if (status != enumCallStatus.received.rawValue) {
                            if userCount == 1 {
                                if (status == enumCallStatus.rejected.rawValue ) {
                                    NotificationCenter.default.post(name: .rejectCall, object:nil)
                                } else if (status == enumCallStatus.ended.rawValue ) {

                                    APP_DELEGATE.providerDelegate.RejectSessionSub(callStatus: enumCallStatus.ended.rawValue)
                                }
                            }
                        }
                    } else if (dic["private_room"] as? String ?? "") == "1" {
                        
                        if ((status == enumCallStatus.received.rawValue) || status == enumCallStatus.calling.rawValue) {
                            Calling.receiver_name = dicMain["user_name"] as? String ?? ""
                            NotificationCenter.default.post(name: .updateName, object:nil)
                        }
                        
                        if (status == enumCallStatus.unanswered.rawValue) {
                            if isHost == "1" {
                                APP_DELEGATE.providerDelegate.RejectSessionSub(callStatus: enumCallStatus.ended.rawValue)
                            }
                        }
                        
                        if isHost == "1" && status == enumCallStatus.ended.rawValue {
                            if userCount == 0 || userCount == 1 {
                                APP_DELEGATE.providerDelegate.RejectSessionSub(callStatus: enumCallStatus.ended.rawValue)
                            }
                        }
                        
                        if (status == enumCallStatus.rejected.rawValue) {
                            if userCount == 1 {
                                APP_DELEGATE.providerDelegate.RejectSessionSub(callStatus: enumCallStatus.ended.rawValue)
                            }
                        }
                    }
                }
            }
        })
	}
    
    //MARK: - Chat Module
    
    func UserBlockedEvent(data:NSDictionary) {
        socket?.emitWithAck(APIConstant.APIUserBlockedEvent, data) .timingOut(after: 0)
        { data in
            
        }
    }
    
    func CheckUserSecurityToken(data:NSDictionary) {
        socket?.emitWithAck(APIConstant.APICheckUserSecurityToken, data) .timingOut(after: 0)
        { data in
            
        }
    }
    
    func getConversation(data:NSDictionary) {
        socket?.emitWithAck(APIConstant.APISocketFetchConversationMessages, data) .timingOut(after: 0) {data in
            if ((data[0] as! NSDictionary).value(forKey: "status")) as! Int == 1 {
            let dic:NSDictionary = (data[0] as! NSDictionary)
           
            let arrMessage = dic.value(forKey: "conversations") as! NSMutableArray
            
            let arrayChat = NSMutableArray()
            for i in 0..<arrMessage.count {
                let dictMessage = arrMessage[i] as! NSMutableDictionary
                let strConversation_id = "\(dictMessage.value(forKey: "conversation_id") ?? "0")"
                let strSender_id = "\(dictMessage.value(forKey: "sender_id") ?? "0")"
                let strReceiver_id = "\(dictMessage.value(forKey: "receiver_id") ?? "0")"
                                
                if self.user_id == Int(strSender_id) {
                                      
                    var receiverName = ""
                    var receiverProfile = ""
                    var receiver_last_seen = ""
                    var receiver_is_online = ""
                    var receiver_chat_status = ""
                    
                    receiverName = "\(dictMessage.value(forKey: "receiver_name") ?? "Cliqued User")"
                    receiverProfile = "\(dictMessage.value(forKey: "receiver_profile") ?? "")"
                    receiver_last_seen = "\(dictMessage.value(forKey: "receiver_last_seen") ?? "")"
                    receiver_is_online = "\(dictMessage.value(forKey: "receiver_is_online") ?? "")"
                    receiver_chat_status = "\(dictMessage.value(forKey: "receiver_chat_status") ?? "")"
                   
                    let dictList = NSMutableDictionary()
                    dictList.setValue(strConversation_id, forKey: "conversation_id")
                    dictList.setValue(strSender_id, forKey: "sender_id")
                    dictList.setValue(strReceiver_id, forKey: "receiver_id")
                    dictList.setValue(receiverName, forKey: "receiver_name")
                    dictList.setValue(receiverProfile, forKey: "receiver_profile")
                    dictList.setValue("\(dictMessage.value(forKey: "created_date") ?? "")", forKey: "created_date")
                    dictList.setValue("\(dictMessage.value(forKey: "modified_date") ?? "")", forKey: "modified_date")
                    dictList.setValue(receiver_last_seen, forKey: "receiver_last_seen")
                    dictList.setValue(receiver_is_online, forKey: "receiver_is_online")
                    dictList.setValue(receiver_chat_status, forKey: "receiver_chat_status")
                    
                    dictList.setValue("\(dictMessage.value(forKey: "message_text") ?? "")", forKey: "message_text")
                    dictList.setValue("\(dictMessage.value(forKey: "message_type") ?? "")", forKey: "message_type")
                    
                    arrayChat.add(dictList)
                } else {
                                        
                    var receiverName = ""
                    var receiverProfile = ""
                    var receiver_last_seen = ""
                    var receiver_is_online = ""
                    var receiver_chat_status = ""
                   
                    receiverName = "\(dictMessage.value(forKey: "sender_name") ?? "Cliqued User")"
                    receiverProfile = "\(dictMessage.value(forKey: "sender_profile") ?? "")"
                    receiver_last_seen = "\(dictMessage.value(forKey: "sender_last_seen") ?? "")"
                    receiver_is_online = "\(dictMessage.value(forKey: "sender_is_online") ?? "")"
                    receiver_chat_status = "\(dictMessage.value(forKey: "sender_chat_status") ?? "")"
                    
                    let dictList = NSMutableDictionary()
                    dictList.setValue(strConversation_id, forKey: "conversation_id")
                    dictList.setValue(strReceiver_id, forKey: "sender_id")
                    dictList.setValue(strSender_id, forKey: "receiver_id")
                    dictList.setValue(receiverName, forKey: "receiver_name")
                    dictList.setValue(receiverProfile, forKey: "receiver_profile")
                    dictList.setValue("\(dictMessage.value(forKey: "created_date") ?? "")", forKey: "created_date")
                    dictList.setValue("\(dictMessage.value(forKey: "modified_date") ?? "")", forKey: "modified_date")
                    dictList.setValue(receiver_last_seen, forKey: "receiver_last_seen")
                    dictList.setValue(receiver_is_online, forKey: "receiver_is_online")
                    dictList.setValue(receiver_chat_status, forKey: "receiver_chat_status")
                    
                    dictList.setValue("\(dictMessage.value(forKey: "message_text") ?? "")", forKey: "message_text")
                    dictList.setValue("\(dictMessage.value(forKey: "message_type") ?? "")", forKey: "message_type")
                    
                    arrayChat.add(dictList)
                }
            }
            
            let _ = CoreDataAdaptor.sharedDataAdaptor.saveConversation(array: arrayChat)
        }
            self.delegate?.reloadConversation?()
        }
    }
    
    func updateUserChatStatus(data:NSDictionary){
        
        let senderId = data.value(forKey: "user_id") as? String
        let receiverId = data.value(forKey: "receiver_id") as? String
        
        socket?.emitWithAck(APIConstant.APISocketGetUserChatStatus, data).timingOut(after: 0) {data in
            let dic:NSDictionary = (data[0] as! NSDictionary)
            print(dic)
            if let arrUser = dic.value(forKey: "User") as? NSMutableArray {
                let dictUser = arrUser[0] as! NSMutableDictionary
                
                let receiverIsOnline = dictUser.value(forKey: "is_online")
                let receiverChatStatus = dictUser.value(forKey: "chat_status")
                let receiverLastSeen = dictUser.value(forKey: "last_seen")
                
                let is_last_seen_enable = dictUser.value(forKey: "is_user_last_seen_enable")
                let is_blocked_by_admin = dictUser.value(forKey: "is_blocked")
                let is_blocked_by_sender = dictUser.value(forKey: "is_blocked_in_app_by_sender")
                let is_blocked_by_receiver = dictUser.value(forKey: "is_blocked_in_app_by_receiver")
                let is_delete = dictUser.value(forKey: "is_deleted")
                
                let updateConStatusFlag = CoreDataAdaptor.sharedDataAdaptor.updateUserChatStatus(senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverIsOnline: "\(receiverIsOnline!)", receiverChatStatus: "\(receiverChatStatus!)", lastseen: "\(receiverLastSeen!)",isLastEnable: "\(is_last_seen_enable!)",isBlockedByAdmin: "\(is_blocked_by_admin!)",isBlockedByUser: "\(is_blocked_by_sender!)",isBlockedByReceiver: "\(is_blocked_by_receiver!)")
                
                let s_id = Int(senderId!)
                let r_id = Int(receiverId!)
                
                self.delegate?.reloadUserChatStatus?(sender_id: s_id!, receiver_id: r_id!,is_delete:is_delete as! String)
            }
        }
    }
    
    func updateMessageStatus(data:NSDictionary){
        
        socket?.emitWithAck(APIConstant.APISOCKETUpdateMessageStatus, data).timingOut(after: 0) {data in
            let dic:NSDictionary = (data[0] as! NSDictionary)
            
            if  let arrMessage = dic.value(forKey: "Conversation") as? NSMutableArray {
            
                for i in 0..<arrMessage.count {
                    let dictMessage = arrMessage[i] as! NSMutableDictionary
                    
                    let msgId = dictMessage.value(forKey: "message_id")
                    let msgText = dictMessage.value(forKey: "message_text")
                    let msgType = dictMessage.value(forKey: "message_type")
                    let mediaId = dictMessage.value(forKey: "media_id")
                    let uniqueId = dictMessage.value(forKey: "unique_message_id")
                    let conversationId = dictMessage.value(forKey: "conversation_id")
                    let senderId = dictMessage.value(forKey: "sender_id")
                    let receiverId = dictMessage.value(forKey: "receiver_id")
                    let modifiedDate = dictMessage.value(forKey: "modified_date")
                    
                    var receiverName = ""
                    var receiverProfile = ""
                    var receiver_last_seen = ""
                    var receiver_is_online = ""
                    var receiver_chat_status = ""
                    var is_blocked_by_admin = ""
                    var is_last_seen_enable = ""
                    var is_blocked_by_user = ""
                    var is_blocked_by_receiver = ""
                    
                    if self.user_id == Int("\(senderId ?? 0)") {
                                                                  
                        receiverName = "\(dictMessage.value(forKey: "receiver_name") ?? "Cliqued User")"
                        receiverProfile = "\(dictMessage.value(forKey: "receiver_profile") ?? "")"
                        receiver_last_seen = "\(dictMessage.value(forKey: "receiver_last_seen") ?? "")"
                        receiver_is_online = "\(dictMessage.value(forKey: "receiver_is_online") ?? "")"
                        receiver_chat_status = "\(dictMessage.value(forKey: "receiver_chat_status") ?? "")"
                        
                        is_blocked_by_admin = "\(dictMessage.value(forKey: "receiver_is_blocked_admin") ?? "")"
                        is_last_seen_enable = "\(dictMessage.value(forKey: "receiver_is_last_seen_enable") ?? "")"
                        is_blocked_by_user = "\(dictMessage.value(forKey: "receiver_blocked_in_app") ?? "")"
                        is_blocked_by_receiver = "\(dictMessage.value(forKey: "sender_blocked_in_app") ?? "")"
                       
                   } else {
                                              
                        receiverName = "\(dictMessage.value(forKey: "sender_name") ?? "Cliqued User")"
                        receiverProfile = "\(dictMessage.value(forKey: "sender_profile") ?? "")"
                        receiver_last_seen = "\(dictMessage.value(forKey: "sender_last_seen") ?? "")"
                        receiver_is_online = "\(dictMessage.value(forKey: "sender_is_online") ?? "")"
                        receiver_chat_status = "\(dictMessage.value(forKey: "sender_chat_status") ?? "")"
                       
                       is_blocked_by_admin = "\(dictMessage.value(forKey: "sender_is_blocked_admin") ?? "")"
                       is_last_seen_enable = "\(dictMessage.value(forKey: "sender_is_last_seen_enable") ?? "")"
                       is_blocked_by_user = "\(dictMessage.value(forKey: "sender_blocked_in_app") ?? "")"
                       is_blocked_by_receiver = "\(dictMessage.value(forKey: "receiver_blocked_in_app") ?? "")"
                    }
                                        
                    let userCallId = dictMessage.value(forKey: "user_call_id")
                    let parentMessageId = dictMessage.value(forKey: "parent_message_id")
                    let forwardedMessageId = dictMessage.value(forKey: "forwared_message_id")
                    let isEdited = dictMessage.value(forKey: "is_edited")
                    let messageStatus = dictMessage.value(forKey: "message_status")
                    let callStatus = dictMessage.value(forKey: "call_status")
                    let host_by = dictMessage.value(forKey: "host_by")
                    let callduration = dictMessage.value(forKey: "call_duration")
                    let thumbnailUrl = dictMessage.value(forKey: "thumbnail_url")
                    
                    let updateConFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversation(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverName: "\(receiverName)", receiverProfile: "\(receiverProfile)", lastDate: "\(modifiedDate!)",messageText: "\(msgText!)",messageType:"\(msgType!)")
                    
                    let updateConStatusFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversationChatStatus(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverIsOnline: "\(receiver_is_online)", receiverChatStatus: "\(receiver_chat_status)", lastseen: "\(receiver_last_seen)",isLastEnable: "\(is_last_seen_enable)",isBlockedByAdmin: "\(is_blocked_by_admin)",isBlockedByUser: "\(is_blocked_by_user)",isBlockedByReceiver: "\(is_blocked_by_receiver)")
                    
                    
                    if (CoreDataAdaptor.sharedDataAdaptor.updateMessageID(messageID: "\(msgId!)", conversationId: "\(conversationId!)", mediaId: "\(mediaId!)", createdDate: dictMessage.value(forKey: "created_date") as! String, modifiedDate: dictMessage.value(forKey: "modified_date") as! String, uniqueId: "\(uniqueId!)", userCallId: "\(userCallId!)", parentMessageId: "\(parentMessageId!)", forwardedMessageId: "\(forwardedMessageId!)", isEdited: "\(isEdited!)", messageStatus: "\(messageStatus!)", callStatus: "\(callStatus!)", host_by: "\(host_by!)", callduration: "\(callduration!)", thumbnailUrl: "\(thumbnailUrl!)")) {
                        
                    }
                }
                self.delegate?.reloadMessagesStatus?()
            }
        }
    }
    
    func sendMessage(data:NSDictionary){

        socket?.emitWithAck(APIConstant.APISOCKETSendNewMessage, data).timingOut(after: 0) {data in
            let dic:NSDictionary = (data[0] as! NSDictionary)
            
            if  let arrMessage = dic.value(forKey: "Conversation") as? NSMutableArray {
            
                let dictMessage = arrMessage[0] as! NSMutableDictionary
                
                let msgId = dictMessage.value(forKey: "message_id")
                let msgText = dictMessage.value(forKey: "message_text")
                let msgType = dictMessage.value(forKey: "message_type")
                let mediaId = dictMessage.value(forKey: "media_id")
                let uniqueId = dictMessage.value(forKey: "unique_message_id")
                let conversationId = dictMessage.value(forKey: "conversation_id")
                let senderId = dictMessage.value(forKey: "sender_id")
                let receiverId = dictMessage.value(forKey: "receiver_id")
                let receiverName = dictMessage.value(forKey: "receiver_name")
                let receiverProfile = dictMessage.value(forKey: "receiver_profile")
                let modifiedDate = dictMessage.value(forKey: "modified_date")
                
                let receiverLastSeen = dictMessage.value(forKey: "receiver_last_seen")
                let receiverIsOnline = dictMessage.value(forKey: "receiver_is_online")
                let receiverChatStatus = dictMessage.value(forKey: "receiver_chat_status")
                
                let is_blocked_by_admin = dictMessage.value(forKey: "receiver_is_blocked_admin")
                let is_last_seen_enable = dictMessage.value(forKey: "receiver_is_last_seen_enable")
                let is_blocked_by_user = dictMessage.value(forKey: "receiver_blocked_in_app")
                let is_blocked_by_sender = dictMessage.value(forKey: "sender_blocked_in_app")
                
                let userCallId = dictMessage.value(forKey: "user_call_id")
                let parentMessageId = dictMessage.value(forKey: "parent_message_id")
                let forwardedMessageId = dictMessage.value(forKey: "forwared_message_id")
                let isEdited = dictMessage.value(forKey: "is_edited")
                let messageStatus = dictMessage.value(forKey: "message_status")
                let callStatus = dictMessage.value(forKey: "call_status")
                let host_by = dictMessage.value(forKey: "host_by")
                let callduration = dictMessage.value(forKey: "call_duration")
                let thumbnailUrl = dictMessage.value(forKey: "thumbnail_url")                
                
                let updateConFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversation(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverName: "\(receiverName!)", receiverProfile: "\(receiverProfile!)", lastDate: "\(modifiedDate!)",messageText: "\(msgText!)",messageType:"\(msgType!)")
                
                let updateConStatusFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversationChatStatus(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverIsOnline: "\(receiverIsOnline!)", receiverChatStatus: "\(receiverChatStatus!)", lastseen: "\(receiverLastSeen!)",isLastEnable: "\(is_last_seen_enable!)",isBlockedByAdmin: "\(is_blocked_by_admin!)",isBlockedByUser: "\(is_blocked_by_user!)",isBlockedByReceiver: "\(is_blocked_by_sender!)")
                
                if (CoreDataAdaptor.sharedDataAdaptor.updateMessageID(messageID: "\(msgId!)", conversationId: "\(conversationId!)", mediaId: "\(mediaId!)", createdDate: dictMessage.value(forKey: "created_date") as! String, modifiedDate: dictMessage.value(forKey: "modified_date") as! String, uniqueId: "\(uniqueId!)", userCallId: "\(userCallId!)", parentMessageId: "\(parentMessageId!)", forwardedMessageId: "\(forwardedMessageId!)", isEdited: "\(isEdited!)", messageStatus: "\(messageStatus!)", callStatus: "\(callStatus!)", host_by: "\(host_by!)", callduration: "\(callduration!)", thumbnailUrl: "\(thumbnailUrl!)")) {
                    self.delegate?.reloadMessages?()
                }
            }
        }
    }
    
    func fetchNewMessagesOfSender(data:NSDictionary)  {

        socket?.emitWithAck(APIConstant.APISocketFetchMessages, data).timingOut(after: 0) {data in
                print(data)
            if ((data[0] as! NSDictionary).value(forKey: "status")) as! Int == 1 {
                
                if (data[0] as! NSDictionary).value(forKey: "Messages") as? NSArray != nil {
                    let array:NSArray = (data[0] as! NSDictionary).value(forKey: "Messages") as! NSArray
                    
                    if array.count > 0 {
                        let dictMessage = array.lastObject as! NSMutableDictionary
                       
                        let msgText = dictMessage.value(forKey: "message_text")
                        let msgType = dictMessage.value(forKey: "message_type")
                        let conversationId = dictMessage.value(forKey: "conversation_id")
                        let senderId = dictMessage.value(forKey: "sender_id")
                        let receiverId = dictMessage.value(forKey: "receiver_id")
                        let receiverName = dictMessage.value(forKey: "receiver_name")
                        let receiverProfile = dictMessage.value(forKey: "receiver_profile")
                        
                        let receiverLastSeen = dictMessage.value(forKey: "receiver_last_seen")
                        let receiverIsOnline = dictMessage.value(forKey: "receiver_is_online")
                        let receiverChatStatus = dictMessage.value(forKey: "receiver_chat_status")
                        
                        let receiver_is_blocked_by_admin = dictMessage.value(forKey: "receiver_is_blocked_admin")
                        let receiver_is_last_seen_enable = dictMessage.value(forKey: "receiver_is_last_seen_enable")
                        let receiver_is_blocked_by_user = dictMessage.value(forKey: "receiver_blocked_in_app")
                        
                        let senderName = dictMessage.value(forKey: "sender_name")
                        let senderProfile = dictMessage.value(forKey: "sender_profile")
                        let modifiedDate = dictMessage.value(forKey: "modified_date")
                        
                        let senderLastSeen = dictMessage.value(forKey: "sender_last_seen")
                        let senderIsOnline = dictMessage.value(forKey: "sender_is_online")
                        let senderChatStatus = dictMessage.value(forKey: "sender_chat_status")
                        
                        let sender_is_blocked_by_admin = dictMessage.value(forKey: "sender_is_blocked_admin")
                        let sender_is_last_seen_enable = dictMessage.value(forKey: "sender_is_last_seen_enable")
                        let sender_is_blocked_by_user = dictMessage.value(forKey: "sender_blocked_in_app")
                        
                        
                        if self.user_id == Int("\(senderId!)") {
                        
                            let updateConFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversation(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverName: "\(receiverName!)", receiverProfile: "\(receiverProfile!)", lastDate: "\(modifiedDate!)",messageText: "\(msgText!)",messageType:"\(msgType!)")
                            
                            let updateConStatusFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversationChatStatus(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverIsOnline: "\(receiverIsOnline!)", receiverChatStatus: "\(receiverChatStatus!)", lastseen: "\(receiverLastSeen!)",isLastEnable: "\(receiver_is_last_seen_enable!)",isBlockedByAdmin: "\(receiver_is_blocked_by_admin!)",isBlockedByUser: "\(receiver_is_blocked_by_user!)",isBlockedByReceiver: "\(sender_is_blocked_by_user!)")
                            
                        } else {
                            let updateConFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversation(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverName: "\(senderName!)", receiverProfile: "\(senderProfile!)", lastDate: "\(modifiedDate!)",messageText: "\(msgText!)",messageType:"\(msgType!)")
                            
                            let updateConStatusFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversationChatStatus(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverIsOnline: "\(senderIsOnline!)", receiverChatStatus: "\(senderChatStatus!)", lastseen: "\(senderLastSeen!)",isLastEnable: "\(sender_is_last_seen_enable!)",isBlockedByAdmin: "\(sender_is_blocked_by_admin!)",isBlockedByUser: "\(sender_is_blocked_by_user!)",isBlockedByReceiver: "\(receiver_is_blocked_by_user!)")
                        }
                        
                        let dict1:NSMutableDictionary = NSMutableDictionary()
                        dict1.setValue("\(Constants.loggedInUser?.id ?? 0)", forKey: "receiver_id")
                        dict1.setValue("0", forKey: "message_id")
                        dict1.setValue("0", forKey: "sender_id")
                        dict1.setValue("\(enumMessageStatus.read.rawValue)", forKey: "message_status")
                        self.updateMessageStatus(data: dict1)
                    
                        let arrayObjMessage = CoreDataAdaptor.sharedDataAdaptor.saveMessage(array: array)
                        if arrayObjMessage.count != 0 {
                                self.delegate?.InitialMessage?(array: arrayObjMessage)
                        } else {
                            self.delegate?.reloadMessages?()
                        }
                    } else {
                        self.delegate?.reloadMessages?()
                    }
                } else {
                    self.delegate?.reloadMessages?()
                }
            } else {
                self.delegate?.reloadMessages?()
            }
        }
    }
    
    func fetchOldMessagesOfSender(data:NSDictionary)  {
        socket?.emitWithAck(APIConstant.APISocketFetchOldMessages, data).timingOut(after: 0) {data in
               
            if ((data[0] as! NSDictionary).value(forKey: "status")) as! Int == 1 {
                
                if (data[0] as! NSDictionary).value(forKey: "Messages") as? NSArray != nil {
                    let array:NSArray = (data[0] as! NSDictionary).value(forKey: "Messages") as! NSArray
                    
                    if array.count > 0 {
                        let dictMessage = array.lastObject as! NSMutableDictionary
                       
                        let msgText = dictMessage.value(forKey: "message_text")
                        let msgType = dictMessage.value(forKey: "message_type")
                        let conversationId = dictMessage.value(forKey: "conversation_id")
                        let senderId = dictMessage.value(forKey: "sender_id")
                        let receiverId = dictMessage.value(forKey: "receiver_id")
                        let receiverName = dictMessage.value(forKey: "receiver_name")
                        let receiverProfile = dictMessage.value(forKey: "receiver_profile")
                        let modifiedDate = dictMessage.value(forKey: "modified_date")
                        let senderName = dictMessage.value(forKey: "sender_name")
                        let senderProfile = dictMessage.value(forKey: "sender_profile")
                        
                        let receiverLastSeen = dictMessage.value(forKey: "receiver_last_seen")
                        let receiverIsOnline = dictMessage.value(forKey: "receiver_is_online")
                        let receiverChatStatus = dictMessage.value(forKey: "receiver_chat_status")
                        
                        let receiver_is_blocked_by_admin = dictMessage.value(forKey: "receiver_is_blocked_admin")
                        let receiver_is_last_seen_enable = dictMessage.value(forKey: "receiver_is_last_seen_enable")
                        let receiver_is_blocked_by_user = dictMessage.value(forKey: "receiver_blocked_in_app")
                                             
                        let senderLastSeen = dictMessage.value(forKey: "sender_last_seen")
                        let senderIsOnline = dictMessage.value(forKey: "sender_is_online")
                        let senderChatStatus = dictMessage.value(forKey: "sender_chat_status")
                        
                        let sender_is_blocked_by_admin = dictMessage.value(forKey: "sender_is_blocked_admin")
                        let sender_is_last_seen_enable = dictMessage.value(forKey: "sender_is_last_seen_enable")
                        let sender_is_blocked_by_user = dictMessage.value(forKey: "sender_blocked_in_app")
                        
                        
                        if self.user_id == Int("\(senderId!)") {
                        
                            let updateConFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversation(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverName: "\(receiverName!)", receiverProfile: "\(receiverProfile!)", lastDate: "\(modifiedDate!)",messageText: "\(msgText!)",messageType:"\(msgType!)")
                            
                            let updateConStatusFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversationChatStatus(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverIsOnline: "\(receiverIsOnline!)", receiverChatStatus: "\(receiverChatStatus!)", lastseen: "\(receiverLastSeen!)",isLastEnable: "\(receiver_is_last_seen_enable!)",isBlockedByAdmin: "\(receiver_is_blocked_by_admin!)",isBlockedByUser: "\(receiver_is_blocked_by_user!)",isBlockedByReceiver: "\(sender_is_blocked_by_user!)")
                            
                        } else {
                            let updateConFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversation(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverName: "\(senderName!)", receiverProfile: "\(senderProfile!)", lastDate: "\(modifiedDate!)",messageText: "\(msgText!)",messageType:"\(msgType!)")
                            
                            let updateConStatusFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversationChatStatus(conversationId: "\(conversationId!)", senderId: "\(senderId!)", receiverId: "\(receiverId!)", receiverIsOnline: "\(senderIsOnline!)", receiverChatStatus: "\(senderChatStatus!)", lastseen: "\(senderLastSeen!)",isLastEnable: "\(sender_is_last_seen_enable!)",isBlockedByAdmin: "\(sender_is_blocked_by_admin!)",isBlockedByUser: "\(sender_is_blocked_by_user!)",isBlockedByReceiver: "\(receiver_is_blocked_by_user!)")
                        }
                         
                        let arrayObjMessage = CoreDataAdaptor.sharedDataAdaptor.saveMessage(array: array)
                        if arrayObjMessage.count != 0 {
                                self.delegate?.InitialMessage?(array: arrayObjMessage)
                        } else {
                            self.delegate?.reloadMessages?()
                        }
                    } else {
                        self.delegate?.reloadMessages?()
                    }
                } else {
                    self.delegate?.reloadMessages?()
                }
            } else {
                self.delegate?.reloadMessages?()
            }
        }
    }
    
    func VideoCallCreateRoom(data:NSDictionary,response: @escaping () -> Void,
                             error: @escaping () -> Void)  {
                
        socket?.emitWithAck(APIConstant.APISocketCreateRoomForVideoCall, data).timingOut(after: 0) {data in
            print(data)
            if ((data[0] as! NSDictionary).value(forKey: "status")) as! Int == 1 {
                let dic:NSDictionary = (data[0] as! NSDictionary)
              
                
                Calling.room_sid = dic["room_sid"] as? String ?? ""
                Calling.room_Name = dic["room_name"] as? String ?? ""
                Calling.sender_access_token = dic["sender_access_token"] as? String ?? ""
                Calling.call_id = dic["call_id"] as? String ?? ""
                Calling.is_privateRoom = (dic["private_room"] as? String ?? "0")
                Calling.is_host = dic["is_host"] as? String ?? ""
                Calling.call_start_time = dic["call_start_time"] as? String  ?? ""
                Calling.call_status = enumCallStatus.calling.rawValue
                response()
            }
        }
    }
    
    func checkNewMessage(data:NSDictionary) {
       
        socket?.emit(APIConstant.APISOCKETGetNewMessage, data)
    }
    
    func updateCallStatusParticipants(data: NSDictionary,response: @escaping () -> Void,
                                      error: @escaping () -> Void) {
        
        
        socket?.emitWithAck(APIConstant.APISocketUpdateCallStatusParticipants, data).timingOut(after: 0) { data in
          
            
            if let dic = data[0] as? NSDictionary {
                Calling.call_id = (dic["result"] as! NSDictionary)["call_id"] as? String ?? ""
                Calling.is_privateRoom = (dic["result"] as! NSDictionary)["private_room"] as? String ?? ""
                Calling.is_host = (dic["result"] as! NSDictionary)["is_host"] as? String ?? ""
                Calling.room_sid = (dic["result"] as! NSDictionary)["room_sid"] as? String ?? ""
                Calling.call_start_time = dic["call_start_time"] as? String ?? ""
                Calling.call_status = dic["call_status"] as? String ?? ""
                response()
            }
        }
    }
    
    func fetchVideocallParticipants(data: NSDictionary,response: @escaping () -> Void,
                                    error: @escaping () -> Void) {
        
        socket?.emitWithAck(APIConstant.APIFetchVideocallParticipants, data).timingOut(after: 0) { data in
            
            if let dic = data[0] as? NSDictionary {
                Calling.call_start_time = dic["call_start_time"] as? String ?? ""
                var arrOnlineUsersImg = [String]()
                if let array = dic.value(forKey: "user") as? NSArray {
                    if array.count > 1 {
                        if let dictObj = (array[0] as? NSDictionary) {
                            arrOnlineUsersImg.append(dictObj["sender_profile"] as? String ?? "")                        }
                    }
                    for obj in array {
                        if array.count == 1 {
                            if let dictObj = (obj as? NSDictionary) {
                                arrOnlineUsersImg.append(dictObj["sender_profile"] as? String ?? "")
                            }
                        }else {
                            if let dictObj = (obj as? NSDictionary) {
                                if dictObj["receiver_id"] as? Int != Constants.loggedInUser?.id {
                                    arrOnlineUsersImg.append(dictObj["profile_photo"] as? String ?? "")
                                }
                            }
                        }
                    }
                }
                NotificationCenter.default.post(name: .audioCallList, object: arrOnlineUsersImg)
                response()
            }
        }
    }
}

