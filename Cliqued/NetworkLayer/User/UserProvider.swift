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
    case updateUser(user: User)
    case updateUserMedia(user: User, image: UIImage)
    case matches
    case potentialMatches
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser, .matches, .potentialMatches:
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
        case .getUser, .deleteUser, .matches, .potentialMatches:
            return .requestPlain
        case .updateUser(let user):
            return .requestCustomJSONEncodable(user, encoder: JSONEncoder())
        case .updateUserMedia(let user, let image):
            let imageData = image.jpegData(compressionQuality: 0)
            let memberIdData = "\(user.id ?? 0)".data(using: String.Encoding.utf8) ?? Data()
            var formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(imageData!), name: "profile_image", fileName: "asdas.png", mimeType: "image/jpeg")]
            formData.append(Moya.MultipartFormData(provider: .data(memberIdData), name: "user_id"))
            return .uploadMultipart(formData)
        }
    }
    
    var headers: [String : String]? {
        guard let userToken = UserDefaults.standard.string(forKey: kUserToken) else {
            return nil
        }
        
        var header = ["Authorization": "Bearer \(userToken)",
                      "Accept": "application/json"]
        
        for headerKey in includeSecurityCredentials() {
            header[headerKey.key as! String] = headerKey.value as? String
        }
        
        return header
    }
}
