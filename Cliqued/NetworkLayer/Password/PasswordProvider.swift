//
//  PasswordProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import Foundation
import Moya

enum PasswordProvider {
    case changePassword(parameters: [String: Any])
    case sendOTPForPassword(parameters: [String: Any])
    case verifyOTPForPassword(token: String)
}

extension PasswordProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://cliqued.michal.es/api")!
    }
    
    var path: String {
        switch self {
        case .changePassword:
            return "/changePassword"
        case .sendOTPForPassword:
            return "/sentOTPForPassword"
        case .verifyOTPForPassword(let token):
            return "/verifyOTPForPassword/\(token)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .changePassword, .sendOTPForPassword:
            return .post
        case .verifyOTPForPassword:
            return .get
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .verifyOTPForPassword:
            return .requestPlain
        case .changePassword(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .sendOTPForPassword(let parameters):
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
