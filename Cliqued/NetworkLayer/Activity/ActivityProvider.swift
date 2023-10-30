//
//  ActivityProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 29.09.2023.
//

import UIKit
import Moya

enum ActivityProvider {
    case getUserActivities
    case createActivity(parameters: [String: Any])
    case updateActivity(activityID: String, parameters: [String: Any])
    case updateActivityMedia(id: String, image: UIImage)
    case deleteActivity(id: String)
    case getInterestedActivityUsers(id: String)
}

extension ActivityProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.cliqued.app/api")!
    }
    
    var path: String {
        switch self {
        case .getUserActivities, .createActivity:
            return "/user_activities"
        case .updateActivity(let id, _):
            return "/user_activities/\(id)"
        case .updateActivityMedia(let id, _):
            return "/user_activities/\(id)/medias"
        case .deleteActivity(let id):
            return "/user_activities/\(id)"
        case .getInterestedActivityUsers(let id):
            return "/user_activities/\(id)/interested_people"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserActivities, .getInterestedActivityUsers:
            return .get
        case .createActivity, .updateActivityMedia:
            return .post
        case .updateActivity:
            return .patch
        case .deleteActivity:
            return .delete
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .getUserActivities, .deleteActivity, .getInterestedActivityUsers:
            return .requestPlain
        case .createActivity(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateActivity(_, let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateActivityMedia(_, let image):
            let data = image.jpegData(compressionQuality: 0.5)!
            
            let gifData = MultipartFormData(provider: .data(data), name: "file", fileName: "gif.lpeg", mimeType: "image/lpeg")
            let multipartData = [gifData]
            
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
