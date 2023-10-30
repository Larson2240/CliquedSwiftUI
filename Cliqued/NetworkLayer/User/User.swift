//
//  User.swift
//
//  Created by C211 on 25/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ApiUserModel: Codable {
    let email: String
    let user: User
}

struct User: Codable {
    var id: Int?
    var isOnline: Bool?
    var aboutMe: String?
    var preferenceAgeTo, preferenceAgeFrom: Int?
    var profileSetupType: Int?
    var name: String?
    var preferenceRomance: Int?
    var userSubscriptionDetails: [UserSubscriptionDetail]?
    var userProfileMedia: [UserProfileMedia]?
    var gender: Int?
    var age: Int?
    var distance: Int?
    var preferenceKids: Bool?
    var favouriteActivityCategories: [Activity]?
    var preferenceDistance: Int?
    var birthdate: String?
    var height: Int?
    var userAddress: Address?
    var preferenceFriendship: Int?
    var isUserLastSeenEnable: Bool?
    var preferenceSmoking: Bool?
    var userSettings: [UserSetting]?
    var notifications: Int?
    
    func profileSetupCompleted() -> Bool {
        return profileSetupType == 10
    }
    
    func userAge() -> Int {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let birthdate = birthdate, let date = dateFormatter.date(from: birthdate) else { return 0 }
        
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: date, to: now)
        guard let age = ageComponents.year else { return 0 }
        
        return age
    }
}

struct Address: Codable {
    let address, city: String
    let longitude: Double
    let country: String
    let latitude: Double
    let pincode, state: String
}

struct UserProfileMedia: Codable, Equatable, Identifiable {
    let id, mediaType: Int?
    let url: String
    let position: Int?
}

struct UserSetting: Codable {
    let setting: Setting
    let value: Bool
}

struct Setting: Codable {
    let id: Int
    let code: String
}

struct UserSubscriptionDetail: Codable {
    let amount: Int
    let isActive: Bool
    let subscription: Subscription
    let transactionEndDate: String
}

struct Subscription: Codable {
    let title, subTitle, planDuration: String
}
