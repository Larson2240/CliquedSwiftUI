//
//  UserInterestedActivityProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import UIKit
import Moya

enum UserInterestedActivityProvider {
    case getUserInterestedActivities
    case postUserInterestedActivity(parameters: [String: Any])
}

extension UserInterestedActivityProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.cliqued.app/api")!
    }
    
    var path: String {
        switch self {
        case .getUserInterestedActivities, .postUserInterestedActivity:
            return "/user_interested_activities"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInterestedActivities:
            return .get
        case .postUserInterestedActivity:
            return .post
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .getUserInterestedActivities:
            return .requestPlain
        case .postUserInterestedActivity(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = ["Accept": "application/json"]
        
        if let userCookie = UserDefaults.standard.string(forKey: kUserCookie), let rememberME = UserDefaults.standard.string(forKey: kUserRememberMe) {
            header["Cookie"] = userCookie + ";" + rememberME
        }
        
        return header
    }
}
