//
//  UserProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 27.09.2023.
//

import Foundation
import Moya

enum UserProvider {
    case getUser
    case deleteUser
    case updateUser(user: User)
}

extension UserProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://cliqued.michal.es/api")!
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "/user"
        case .deleteUser:
            return "/user/delete"
        case .updateUser:
            return "/user/update"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser:
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
        case .getUser, .deleteUser:
            return .requestPlain
        case .updateUser(let user):
            return .requestCustomJSONEncodable(user, encoder: JSONEncoder())
        }
    }
    
    var headers: [String : String]? {
        guard let userToken = UserDefaults.standard.string(forKey: kUserToken) else {
            return nil
        }
        
        return ["Authorization": "Bearer \(userToken)"]
    }
}
