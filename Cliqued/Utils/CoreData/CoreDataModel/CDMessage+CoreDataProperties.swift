//
//  CDMessage+CoreDataProperties.swift
//  Cliqued
//
//  Created by C100-132 on 10/02/23.
//
//

import Foundation
import CoreData


extension CDMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMessage> {
        return NSFetchRequest<CDMessage>(entityName: "CDMessage")
    }

    @NSManaged public var callDuration: String?
    @NSManaged public var callStatus: String?
    @NSManaged public var conversationId: Int64
    @NSManaged public var createdDate: Date?
    @NSManaged public var forwaredMessageId: Int64
    @NSManaged public var hostBy: Int64
    @NSManaged public var id: Int64
    @NSManaged public var isEdited: String?
    @NSManaged public var mediaType: String?
    @NSManaged public var mediaUrl: String?
    @NSManaged public var messageId: Int64
    @NSManaged public var messageStatus: String?
    @NSManaged public var messageText: String?
    @NSManaged public var messageType: String?
    @NSManaged public var modifiedDate: Date?
    @NSManaged public var parentMessageId: Int64
    @NSManaged public var receiverId: Int64
    @NSManaged public var senderId: Int64
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var uniqueId: String?
    @NSManaged public var userCallId: Int64
    @NSManaged public var isBlocked: String?

}

extension CDMessage : Identifiable {

}
