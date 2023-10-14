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
    case updateUserMedia(image: UIImage, position: Int)
    case matches
    case potentialMatches
    case activityMatches
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
        case .matches:
            return "/user/matches"
        case .potentialMatches:
            return "/user/potential_matches"
        case .updateUserMedia:
            return "/user_profile_media"
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
        case .updateUserMedia:
            return .post
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .getUser, .deleteUser, .matches, .potentialMatches, .activityMatches:
            return .requestPlain
        case .updateUser(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateUserMedia(let image, let position):
            let data = image.jpegData(compressionQuality: 0.5)!
            
            let gifData = MultipartFormData(provider: .data(data), name: "file", fileName: "gif.lpeg", mimeType: "image/lpeg")
            let descriptionData = MultipartFormData(provider: .data(withUnsafeBytes(of: position, { Data($0) })), name: "position")
            let multipartData = [gifData, descriptionData]
            
            return .uploadMultipart(multipartData)
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
