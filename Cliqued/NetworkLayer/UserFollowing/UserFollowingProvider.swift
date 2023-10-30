//
//  UserFollowingProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 16.10.2023.
//

import UIKit
import Moya

enum UserFollowingProvider {
    case getUserFollowers
    case followUser(parameters: [String: Any])
}

extension UserFollowingProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.cliqued.app/api")!
    }
    
    var path: String {
        return "/user_followings"
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserFollowers:
            return .get
        case .followUser:
            return .post
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .getUserFollowers:
            return .requestPlain
        case .followUser(let parameters):
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
