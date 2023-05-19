//
//  CDConversation+CoreDataProperties.swift
//  Cliqued
//
//  Created by C100-132 on 17/04/23.
//
//

import Foundation
import CoreData


extension CDConversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDConversation> {
        return NSFetchRequest<CDConversation>(entityName: "CDConversation")
    }

    @NSManaged public var chatStatus: String?
    @NSManaged public var conversationId: Int64
    @NSManaged public var createdDate: Date?
    @NSManaged public var id: Int64
    @NSManaged public var isBlockByAdmin: String?
    @NSManaged public var isBlockedBySender: String?
    @NSManaged public var isLastSeenEnabled: String?
    @NSManaged public var isOnline: String?
    @NSManaged public var lastSeen: Date?
    @NSManaged public var messageText: String?
    @NSManaged public var messageType: String?
    @NSManaged public var modifiedDate: Date?
    @NSManaged public var receiverId: Int64
    @NSManaged public var receiverName: String?
    @NSManaged public var receiverProfile: String?
    @NSManaged public var senderId: Int64
    @NSManaged public var isBlockedByReceiver: String?

}

extension CDConversation : Identifiable {

}
