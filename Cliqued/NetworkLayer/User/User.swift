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
    var distance: Int?
    var preferenceRomance: Int?
    var preferenceFriendship: Int?
    var address: Address?
    var modifiedDate: String?
    var profileSetupType: String?
    var isProfileSetupCompleted: Int?
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
    var userProfileImages: [UserProfileImages]?
    var likesCounter: Int?
    var height: Int?
    var isBlocked: String?
    var userMergeIds: String?
    var isUserLastSeenEnable: Bool?

    var kids: Bool?
    var smoking: Bool?
    var notifications: Int?
    var ageFrom: Int?
    var ageTo: Int?
    
    var aboutMe: String?
    var chatStatus: Bool?
    var activityCount: Int?
    var userProfileViewCount: Int?
    var activityUserViewCount: Int?
    var isPremiumUser: String?
    var lookingForTitle: String?
}

struct Address: Codable {
    let address: String
    let latitude, longitude: Int
    let city, state, country, pincode: String
}
