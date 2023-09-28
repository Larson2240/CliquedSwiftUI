//
//  User.swift
//
//  Created by C211 on 25/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ApiUserModel: Codable {
    let user: User
}

struct User: Codable {
    var gender: Int?
    var name: String?
    var age: Int?
    var preferenceDistance: Int?
    var preferenceRomance: Int?
    var preferenceFriendship: Int?
    var userAddress: Address?
    var modifiedDate: String?
    var profileSetupType: Int?
    var connectedAccount: [ConnectedAccount]?
    var isTestdata: String?
    var birthdate: String?
    var lastSeen: String?
    var isOnline: Bool?
    var isVerified: String?
    var interestedActivityCategories: [Int]?
    var interestedActivitySubcategories: [Int]?
    var createdDate: String?
    var id: Int?
    var guid: String?
    var userProfileMedia: [UserProfileImages]?
    var likesCounter: Int?
    var height: Int?
    var isBlocked: String?
    var userMergeIds: String?
    var isUserLastSeenEnable: Bool?

    var preferenceKids: Bool?
    var preferenceSmoking: Bool?
    var notifications: Int?
    var preferenceAgeFrom: Int?
    var preferenceAgeTo: Int?
    
    var aboutMe: String?
    var chatStatus: Bool?
    var activityCount: Int?
    var userProfileViewCount: Int?
    var activityUserViewCount: Int?
    var isPremiumUser: String?
    var lookingForTitle: String?
    
    func profileSetupCompleted() -> Bool {
        return profileSetupType == 1
    }
}

struct Address: Codable {
    let address: String
    let latitude, longitude: Int
    let city, state, country, pincode: String
}
