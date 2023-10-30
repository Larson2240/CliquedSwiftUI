//
//  UserProfileMediaProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import UIKit
import Moya

enum UserProfileMediaProvider {
    case postUserMedia(image: UIImage, position: Int)
    case updateUserMediaPosition(id: String, position: Int)
    case deleteUserMedia(id: String)
}

extension UserProfileMediaProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.cliqued.app/api")!
    }
    
    var path: String {
        switch self {
        case .postUserMedia:
            return "/user_profile_media"
        case .updateUserMediaPosition(let id, _), .deleteUserMedia(let id):
            return "/user_profile_media/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postUserMedia:
            return .post
        case .updateUserMediaPosition:
            return .patch
        case .deleteUserMedia:
            return .delete
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .deleteUserMedia:
            return .requestPlain
        case .updateUserMediaPosition(_, let position):
            return .requestParameters(parameters: ["position": position], encoding: JSONEncoding.default)
        case .postUserMedia(let image, let position):
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
