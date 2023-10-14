//
//  UserActivityClass.swift
//
//  Created by C100-132 on 03/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct UserActivityClass: Codable {
    let id: Int
    let description, state: String
    let expired: Bool
    let longitude: Double
    let medias: [Media]
    let latitude: Double
    let title, address, pincode, city: String
    let activityDate: String
    let activityCategories: [String]
    let user, country: String
}
