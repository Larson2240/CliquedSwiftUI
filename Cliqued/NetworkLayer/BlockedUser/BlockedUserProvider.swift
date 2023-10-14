//
//  BlockedUserProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import Foundation
import Moya

enum BlockedUserProvider {
    case getBlockedUsers
    case blockUser(parameters: [String: Any])
    case updateBlockedUser(userID: String, parameters: [String: Any])
}

extension BlockedUserProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://cliqued.michal.es/api")!
    }
    
    var path: String {
        switch self {
        case .getBlockedUsers, .blockUser:
            return "/blocked_users"
        case .updateBlockedUser(let userID, _):
            return "/blocked_users/\(userID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBlockedUsers:
            return .get
        case .blockUser:
            return .post
        case .updateBlockedUser:
            return .patch
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .getBlockedUsers:
            return .requestPlain
        case .blockUser(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateBlockedUser(_, let parameters):
            return .requestParameters(parameters: parameters,encoding: JSONEncoding.default)
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
