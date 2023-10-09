//
//  ActivityProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 29.09.2023.
//

import Foundation
import Moya

enum ActivityProvider {
    case getActivityCategories
    case getUserActivities
}

extension ActivityProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://cliqued.michal.es/api")!
    }
    
    var path: String {
        switch self {
        case .getActivityCategories:
            return "/activity_categories"
        case .getUserActivities:
            return "/user_activities"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getActivityCategories, .getUserActivities:
            return .get
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .getActivityCategories, .getUserActivities:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var header = ["Accept": "application/json"]
        
        if let userCookie = UserDefaults.standard.string(forKey: kUserCookie) {
            header["Cookie"] = userCookie
        }
        
        return header
    }
}
