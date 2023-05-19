//
//  CoreDataAdaptor.swift
//  Kideo
//
//  Created by NC2-38 on 15/12/17.
//  Copyright © 2017 NC2-38. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CoreDataAdaptor: NSObject {
    
    static let sharedDataAdaptor = CoreDataAdaptor()
    var managedContext = CoreDBManager.sharedDatabase.persistentContainer.viewContext
    
    
    //MARK: - Conversation
    func saveConversation(array:NSArray) -> [CDConversation] {
        var arrayObjList:[CDConversation] = []
        
        for data in array {
            
            let obj = data as! NSDictionary
            let strPredicate = "(senderId = \(obj.value(forKey: "sender_id")!) and receiverId = \(obj.value(forKey: "receiver_id")!)) or (senderId = \(obj.value(forKey: "receiver_id")!) and receiverId = \(obj.value(forKey: "sender_id")!))"
            
            let arrayList = fetchListWhere(predicate: NSPredicate (format: strPredicate as String))
            
            var objList = CDConversation()
            if arrayList.count == 0 {
                
                var strId = getLastDefaultIdForConversation()
                strId = strId + 1
                
                objList = CDConversation(entity: CDConversation.entity(), insertInto: managedContext)
                objList.id = Int64(strId)
                
                if let amount = obj.value(forKey: "conversation_id") as? String {
                    objList.conversationId = Int64(amount)!
                }
                else if let amount = obj.value(forKey: "conversation_id") as? Int {
                    objList.conversationId = Int64(amount)
                }
                
                if let amount = obj.value(forKey: "sender_id") as? String {
                    objList.senderId = Int64(amount)!
                }
                else if let amount = obj.value(forKey: "sender_id") as? Int {
                    objList.senderId = Int64(amount)
                }
                
                if let amount = obj.value(forKey: "receiver_id") as? String {
                    objList.receiverId = Int64(amount)!
                } else if let amount = obj.value(forKey: "receiver_id") as? Int {
                    objList.receiverId = Int64(amount)
                }
                
                objList.receiverName = obj.value(forKey: "receiver_name") as? String
                objList.receiverProfile = obj.value(forKey: "receiver_profile") as? String
                
                
                if (obj.value(forKey: "receiver_last_seen") as? String) != nil {
                    let dateFormate = DateFormatter()
                    dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let lastSeendate = dateFormate.date(from: obj.value(forKey: "receiver_last_seen") as! String)
                    objList.lastSeen = lastSeendate
                }
                
                objList.isLastSeenEnabled = obj.value(forKey: "is_last_seen_enable") as? String
                objList.isBlockByAdmin = obj.value(forKey: "is_blocked_by_admin") as? String
                objList.isBlockedBySender = obj.value(forKey: "is_blocked_by_user") as? String
                objList.isBlockedByReceiver = obj.value(forKey: "is_blocked_by_receiver") as? String
                objList.isOnline = obj.value(forKey: "receiver_is_online") as? String
                objList.chatStatus = obj.value(forKey: "receiver_chat_status") as? String
                
                if (obj.value(forKey: "created_date") as? String) != nil && (obj.value(forKey: "modified_date") as? String) != nil {
                    
                    let dateFormate = DateFormatter()
                    dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let cdate = dateFormate.date(from: obj.value(forKey: "created_date") as! String)
                    let mdate = dateFormate.date(from: obj.value(forKey: "modified_date") as! String)
                    
                    objList.createdDate = cdate
                    objList.modifiedDate = mdate
                }
                
                objList.messageText = obj.value(forKey: "message_text") as? String
                objList.messageType = obj.value(forKey: "message_type") as? String
                
                arrayObjList.append(objList)
                
                CoreDBManager.sharedDatabase.saveContext()
                
            } else {
                
                var senderId = 0
                var receiverId = 0
                var conversationId = 0
                
                if let amount = obj.value(forKey: "conversation_id") as? String {
                    conversationId = Int(amount)!
                }
                else if let amount = obj.value(forKey: "conversation_id") as? Int {
                    conversationId = Int(amount)
                }
                
                if let amount = obj.value(forKey: "sender_id") as? String {
                    senderId = Int(amount)!
                }
                else if let amount = obj.value(forKey: "sender_id") as? Int {
                    senderId = Int(amount)
                }
                
                if let amount = obj.value(forKey: "receiver_id") as? String {
                    receiverId = Int(amount)!
                } else if let amount = obj.value(forKey: "receiver_id") as? Int {
                    receiverId = Int(amount)
                }
                                
                var receiverName = obj.value(forKey: "receiver_name") as? String
                var receiver_profile = obj.value(forKey: "receiver_profile") as? String
                var msgText = obj.value(forKey: "message_text") as? String
                var lastDate = obj.value(forKey: "modified_date") as? String
                var msgType = obj.value(forKey: "message_type") as? String
                
                let updateConFlag = CoreDataAdaptor.sharedDataAdaptor.updateConversation(conversationId: "\(conversationId)", senderId: "\(senderId)", receiverId: "\(receiverId)", receiverName: "\(receiverName!)", receiverProfile: "\(receiver_profile!)", lastDate: "\(lastDate!)",messageText: "\(msgText!)",messageType:"\(msgType!)")
               
            }
        }
        
        return arrayObjList
    }
    
    func fetchListWhere(predicate:NSPredicate?, sort:[NSSortDescriptor] = [], limit:Int = 0) -> [CDConversation] {
        
        var arrayList:[CDConversation] = []
        let fetchRequest: NSFetchRequest<CDConversation> =
            CDConversation.fetchRequest()
        fetchRequest.predicate = predicate
        (limit != 0) ? (fetchRequest.fetchLimit = limit) : nil
        (sort.count != 0) ? (fetchRequest.sortDescriptors = sort) : nil
        do {
            arrayList.removeAll()
            arrayList = (try managedContext.fetch(fetchRequest))
        } catch {
            print("Cannot fetch")
        }
        
        return arrayList
    }
    
    func getLastDefaultIdForConversation() -> Int {
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        let arrayMessage = fetchListWhere(predicate:nil, sort:[sortDescriptor], limit:1)
        if arrayMessage.count == 0 {return 0}
        let objMessage = arrayMessage.first
        let str = objMessage!.id
        return Int(str)
    }
    
    func updateConversation(conversationId:String,senderId:String,receiverId:String,receiverName:String,receiverProfile:String,lastDate:String,messageText:String,messageType:String) -> Bool {
        
        let predicate = NSPredicate(format: "(senderId = \(senderId) and receiverId = \(receiverId)) or (senderId = \(receiverId) and receiverId = \(senderId))")
        var arrayList:[CDConversation] = []
        let fetchRequest: NSFetchRequest<CDConversation> = CDConversation.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            arrayList = (try managedContext.fetch(fetchRequest))
            if arrayList.count != 0 {
                let objList = arrayList.first
                objList?.conversationId = Int64(conversationId)!
                objList?.receiverName = receiverName
                objList?.receiverProfile = receiverProfile
                objList?.messageText = messageText
                objList?.messageType = messageType
                
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let cdate = dateFormate.date(from: lastDate)
                objList?.modifiedDate = cdate
                
                CoreDBManager.sharedDatabase.saveContext()
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func updateConversationChatStatus(conversationId:String,senderId:String,receiverId:String,receiverIsOnline:String,receiverChatStatus:String,lastseen:String,isLastEnable: String,isBlockedByAdmin:String,isBlockedByUser:String,isBlockedByReceiver:String) -> Bool {
        
        let predicate = NSPredicate(format: "(senderId = \(senderId) and receiverId = \(receiverId)) or (senderId = \(receiverId) and receiverId = \(senderId))")
        var arrayList:[CDConversation] = []
        let fetchRequest: NSFetchRequest<CDConversation> = CDConversation.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            arrayList = (try managedContext.fetch(fetchRequest))
            if arrayList.count != 0 {
                let objList = arrayList.first
                objList?.conversationId = Int64(conversationId)!
                objList?.isOnline = receiverIsOnline
                objList?.chatStatus = receiverChatStatus
                objList?.isLastSeenEnabled = isLastEnable
                objList?.isBlockedBySender = isBlockedByUser
                objList?.isBlockedByReceiver = isBlockedByReceiver
                objList?.isBlockByAdmin = isBlockedByAdmin
                
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let ldate = dateFormate.date(from: lastseen)
                objList?.lastSeen = ldate
                               
                CoreDBManager.sharedDatabase.saveContext()
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func updateUserChatStatus(senderId:String,receiverId:String,receiverIsOnline:String,receiverChatStatus:String,lastseen:String,isLastEnable: String,isBlockedByAdmin:String,isBlockedByUser:String,isBlockedByReceiver:String) -> Bool {
        
        let predicate = NSPredicate(format: "(senderId = \(senderId) and receiverId = \(receiverId)) or (senderId = \(receiverId) and receiverId = \(senderId))")
        var arrayList:[CDConversation] = []
        let fetchRequest: NSFetchRequest<CDConversation> = CDConversation.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            arrayList = (try managedContext.fetch(fetchRequest))
            if arrayList.count != 0 {
                let objList = arrayList.first               
                objList?.isOnline = receiverIsOnline
                objList?.chatStatus = receiverChatStatus
                objList?.isLastSeenEnabled = isLastEnable
                objList?.isBlockedBySender = isBlockedByUser
                objList?.isBlockByAdmin = isBlockedByAdmin
                objList?.isBlockedByReceiver = isBlockedByReceiver
                
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let ldate = dateFormate.date(from: lastseen)
                objList?.lastSeen = ldate
                               
                CoreDBManager.sharedDatabase.saveContext()
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func updateUserStatus(receiverId:String,receiverChatStatus:String,lastseen:String) -> Bool {
        
        let predicate = NSPredicate(format: "(senderId = \(receiverId) or receiverId = \(receiverId))")
        var arrayList:[CDConversation] = []
        let fetchRequest: NSFetchRequest<CDConversation> = CDConversation.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            arrayList = (try managedContext.fetch(fetchRequest))
            if arrayList.count != 0 {
                let objList = arrayList.first
                
                objList?.chatStatus = receiverChatStatus
                
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let ldate = dateFormate.date(from: lastseen)
                objList?.lastSeen = ldate
                               
                CoreDBManager.sharedDatabase.saveContext()
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func updateConversationLastDate(conversationId:String,lastDate:String) -> Bool {
        
        let predicate = NSPredicate(format: "conversationId = \(conversationId)")
        var arrayList:[CDConversation] = []
        let fetchRequest: NSFetchRequest<CDConversation> = CDConversation.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            arrayList = (try managedContext.fetch(fetchRequest))
            if arrayList.count != 0 {
                let objList = arrayList.first
               
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let cdate = dateFormate.date(from: lastDate)
                objList?.modifiedDate = cdate
                
                CoreDBManager.sharedDatabase.saveContext()
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func deleteAllConversation () {
        let deleteAll = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "CDConversation"))
        do {
            try managedContext.execute(deleteAll)
        }
        catch {
            print(error)
        }
        CoreDBManager.sharedDatabase.saveContext()
    }
    
    //MARK: - Message
    func saveMessage(array:NSArray) -> [CDMessage]
    {
        var arrayObjMessage:[CDMessage] = []
               
        for data in array {
            
            let obj = data as! NSDictionary
            let strPredicate = "uniqueId = '\(obj.value(forKey: "unique_message_id")!)'"
            // let strPredicate1 = NSString(format: "messageId = %d",obj.value(forKey: "id"))
            
            let arrayMessage = fetchMessageWhere(predicate: NSPredicate (format: strPredicate as String))
            
            var objMessage  = CDMessage()
            if arrayMessage.count == 0 {
                
                var strId = getLastDefaultId()
                strId = strId + 1
                
                objMessage = CDMessage(entity: CDMessage.entity(), insertInto: managedContext)
                objMessage.id = Int64(strId)
                
                if let amount = obj.value(forKey: "message_id") as? String {
                    objMessage.messageId = Int64(amount)!
                }
                else if let amount = obj.value(forKey: "message_id") as? Int {
                    objMessage.messageId = Int64(amount)
                }
                
                if let amount = obj.value(forKey: "conversation_id") as? String {
                    objMessage.conversationId = Int64(amount)!
                }
                else if let amount = obj.value(forKey: "conversation_id") as? Int {
                    objMessage.conversationId = Int64(amount)
                }
                
                if let amount = obj.value(forKey: "sender_id") as? String {
                    objMessage.senderId = Int64(amount)!
                }
                else if let amount = obj.value(forKey: "sender_id") as? Int {
                    objMessage.senderId = Int64(amount)
                }
                
                if let amount = obj.value(forKey: "receiver_id") as? String {
                    objMessage.receiverId = Int64(amount)!
                }else if let amount = obj.value(forKey: "receiver_id") as? Int {
                    objMessage.receiverId = Int64(amount)
                }
                
                if let str = obj.value(forKey: "media_url") as? String {
                    objMessage.mediaUrl = str
                } else if let str = obj.value(forKey: "url") as? String {
                    objMessage.mediaUrl = str
                }
                
                objMessage.uniqueId = obj.value(forKey: "unique_message_id") as? String
                objMessage.mediaType = obj.value(forKey: "media_type") as? String
                objMessage.messageText = obj.value(forKey: "message_text") as? String
                objMessage.messageType = obj.value(forKey: "message_type") as? String
                
                if let amount = obj.value(forKey: "user_call_id") as? String {
                    objMessage.userCallId = Int64(amount)!
                }else if let amount = obj.value(forKey: "user_call_id") as? Int {
                    objMessage.userCallId = Int64(amount)
                }
                
                if let amount = obj.value(forKey: "parent_message_id") as? String {
                    objMessage.parentMessageId = Int64(amount)!
                }else if let amount = obj.value(forKey: "parent_message_id") as? Int {
                    objMessage.parentMessageId = Int64(amount)
                }
                
                if let amount = obj.value(forKey: "forwared_message_id") as? String {
                    objMessage.forwaredMessageId = Int64(amount)!
                }else if let amount = obj.value(forKey: "forwared_message_id") as? Int {
                    objMessage.forwaredMessageId = Int64(amount)
                }
                               
                objMessage.isEdited = (obj.value(forKey: "is_edited") as? String)!
                
                if let amount = obj.value(forKey: "is_blocked") as? String {
                    objMessage.isBlocked = amount
                } else {
                    objMessage.isBlocked = "0"
                }
                
                
                objMessage.messageStatus = obj.value(forKey: "message_status") as? String
                objMessage.callStatus = obj.value(forKey: "call_status") as? String
                
                if let amount = obj.value(forKey: "host_by") as? String {
                    objMessage.hostBy = Int64(amount)!
                }else if let amount = obj.value(forKey: "host_by") as? Int {
                    objMessage.hostBy = Int64(amount)
                }
                
                objMessage.callDuration = obj.value(forKey: "call_duration") as? String
                objMessage.thumbnailUrl = obj.value(forKey: "thumbnail_url") as? String
                              
                if (obj.value(forKey: "created_date") as? String) != nil && (obj.value(forKey: "modified_date") as? String) != nil {
                    
                    let dateFormate = DateFormatter()
                    dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let cdate = dateFormate.date(from: obj.value(forKey: "created_date") as! String)
                    let mdate = dateFormate.date(from: obj.value(forKey: "modified_date") as! String)
                    
                    objMessage.createdDate = cdate
                    objMessage.modifiedDate = mdate
                }
                
                arrayObjMessage.append(objMessage)
                
                CoreDBManager.sharedDatabase.saveContext()
            }
        }
        
        return arrayObjMessage
    }
    
    
    func fetchAllMessage() -> [CDMessage] {
        
        var arrayMessage:[CDMessage] = []
        let fetchRequest: NSFetchRequest<CDMessage> = CDMessage.fetchRequest()
        do {
            arrayMessage = (try managedContext.fetch(fetchRequest))
        } catch {
            print("Cannot fetch")
        }
        return arrayMessage
    }
    
    func fetchMessageWhere(predicate:NSPredicate?, sort:[NSSortDescriptor] = [], limit:Int = 0) -> [CDMessage] {
        
        var arrayMessage:[CDMessage] = []
        let fetchRequest: NSFetchRequest<CDMessage> =
            CDMessage.fetchRequest()
        fetchRequest.predicate = predicate
        (limit != 0) ? (fetchRequest.fetchLimit = limit) : nil
        (sort.count != 0) ? (fetchRequest.sortDescriptors = sort) : nil
        do {
            arrayMessage = (try managedContext.fetch(fetchRequest))
        } catch {
            print("Cannot fetch")
        }
        
        return arrayMessage
    }
    
    func fetchMessageWhere1(predicate:NSPredicate?,startOffset :Int, sort:[NSSortDescriptor] = [], limit:Int = 0) -> [CDMessage] {
        
        var arrayMessage:[CDMessage] = []
        let fetchRequest: NSFetchRequest<CDMessage> =
            CDMessage.fetchRequest()
        fetchRequest.predicate = predicate
        (limit != 0) ? (fetchRequest.fetchLimit = limit) : nil
        (sort.count != 0) ? (fetchRequest.sortDescriptors = sort) : nil
        fetchRequest.fetchOffset = startOffset
        do {
            arrayMessage = (try managedContext.fetch(fetchRequest))
        } catch {
            print("Cannot fetch")
        }
        
        return arrayMessage
    }
    
    
    
    func deleteAllMessage () {
        let deleteAll = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "CDMessage"))
        do {
            try managedContext.execute(deleteAll)
        }
        catch {
            print(error)
        }
        CoreDBManager.sharedDatabase.saveContext()
    }
    
    func getLastDefaultId() -> Int {
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        let arrayMessage = fetchMessageWhere(predicate:nil, sort:[sortDescriptor], limit:1)
        if arrayMessage.count == 0 {return 0}
        let objMessage = arrayMessage.first
        let str = objMessage!.id
        return Int(str)
    }
    
    
    func getLastMessageId(sender_id:Int,receiver_id:Int) -> String {
        let sortDescriptor = NSSortDescriptor(key: "messageId", ascending: true)
        let strPredicate = NSString(format: "senderId = %d AND receiverId = %d",sender_id,receiver_id)
        let arrayMessage = fetchMessageWhere(predicate:NSPredicate (format: strPredicate as String), sort:[sortDescriptor], limit:1)
        if arrayMessage.count == 0 {return "0"}
        let objMessage = arrayMessage.first
        let str = "\(objMessage!.messageId)"
        return str
    }
    
    func getMinMessageId(sender_id:String,receiver_id:String) -> String {
        let sortDescriptor = NSSortDescriptor(key: "messageId", ascending: true)
        let strPredicate = NSString(format: "senderId = %@ AND receiverId = %@",sender_id,receiver_id)
        let arrayMessage = fetchMessageWhere(predicate:NSPredicate (format: strPredicate as String), sort:[sortDescriptor], limit:1)
        if arrayMessage.count == 0 {return "0"}
        let objMessage = arrayMessage.first
        let str = "\(objMessage!.messageId)"
        return str
    }
    
    func getLastMessageId1() -> String {
        let sortDescriptor = NSSortDescriptor(key: "messageId", ascending: false)
        let arrayMessage = fetchMessageWhere(predicate:nil, sort:[sortDescriptor], limit:1)
        if arrayMessage.count == 0 {return "0"}
        let objMessage = arrayMessage.first
        let str = "\(objMessage!.messageId)"
        return str
    }
    
    
    func updateMessageID(messageID:String,conversationId:String,mediaId:String,createdDate : String,modifiedDate : String,uniqueId:String, userCallId:String,parentMessageId:String,forwardedMessageId:String,isEdited:String,messageStatus:String,callStatus:String,host_by:String,callduration:String,thumbnailUrl:String ) -> Bool {
        
        let predicate = NSPredicate(format: "uniqueId = '\(uniqueId)'")
        var arrayMessage:[CDMessage] = []
        let fetchRequest: NSFetchRequest<CDMessage> = CDMessage.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            arrayMessage = (try managedContext.fetch(fetchRequest))
            if arrayMessage.count != 0 {
                let objMessage = arrayMessage.first
                objMessage?.messageId = Int64(messageID)!
                objMessage?.conversationId = Int64(conversationId)!
                objMessage?.userCallId = Int64(userCallId)!
                objMessage?.parentMessageId = Int64(parentMessageId)!
                objMessage?.forwaredMessageId = Int64(forwardedMessageId)!
                objMessage?.hostBy = Int64(host_by)!
                objMessage?.isEdited = isEdited
                objMessage?.messageStatus = messageStatus
                objMessage?.callStatus = callStatus
                objMessage?.callDuration = callduration
                objMessage?.thumbnailUrl = thumbnailUrl
//
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let cdate = dateFormate.date(from: createdDate)
                let mdate = dateFormate.date(from: modifiedDate)
                
                objMessage?.modifiedDate = mdate
                objMessage?.createdDate = cdate
                
                CoreDBManager.sharedDatabase.saveContext()
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
