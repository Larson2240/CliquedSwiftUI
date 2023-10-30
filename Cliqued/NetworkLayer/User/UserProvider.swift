//
//  UserProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 27.09.2023.
//

import UIKit
import Moya

enum UserProvider {
    case getUser
    case deleteUser
    case updateUser(parameters: [String: Any])
    case matches
    case potentialMatches
    case activityMatches
}

extension UserProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.cliqued.app/api")!
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "/user"
        case .deleteUser:
            return "/user/delete"
        case .updateUser:
            return "/user/update"
        case .matches:
            return "/user/matches"
        case .potentialMatches:
            return "/user/potential_matches"
        case .activityMatches:
            return "/user/activity_matches"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser, .matches, .potentialMatches, .activityMatches:
            return .get
        case .deleteUser:
            return .delete
        case .updateUser:
            return .patch
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .getUser, .deleteUser, .matches, .potentialMatches, .activityMatches:
            return .requestPlain
        case .updateUser(let parameters):
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
