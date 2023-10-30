//
//  TokenProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import Foundation
import Moya

enum TokenProvider {
    case getTwillioToken(userID: String, roomID: String)
    case updateNotificationToken(parameters: [String: Any])
}

extension TokenProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.cliqued.app/api")!
    }
    
    var path: String {
        switch self {
        case .getTwillioToken(let userID, let roomID):
            return "/getTwilioToken/user/\(userID)/room/\(roomID)"
        case .updateNotificationToken:
            return "/sentOTPForPassword"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTwillioToken:
            return .get
        case .updateNotificationToken:
            return .post
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .getTwillioToken:
            return .requestPlain
        case .updateNotificationToken(let parameters):
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
