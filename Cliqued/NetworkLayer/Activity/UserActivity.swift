//
//  UserActivity.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 08.10.2023.
//

import Foundation

struct UserActivity: Codable {
    let id: Int
    let title, activityDate, city, country: String
    let latitude, longitude: Int
    let user: User
    let media: [Media]
}

struct Media: Codable {
    let id: Int
    let url: String
}
