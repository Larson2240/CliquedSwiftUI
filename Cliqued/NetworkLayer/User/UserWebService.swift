//
//  UserWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 27.09.2023.
//

import SwiftUI
import Moya

final class UserWebService {
    private let userProvider = MoyaProvider<UserProvider>(plugins: [VerbosePlugin()])
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
    func getUser(completion: @escaping (Result<User, Error>) -> Void) {
        userProvider.request(.getUser) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode(ApiUserModel.self, from: response.data)
                    completion(.success(model.user))
                } catch let error {
                    print(error)
                    
                    if let model = try? JSONDecoder().decode(ApiErrorModel.self, from: response.data) {
                        completion(.failure(ApiError.custom(errorDescription: model.message)))
                    } else {
                        completion(.failure(ApiError.parsing))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteUser(completion: @escaping (Result<Void, Error>) -> Void) {
        userProvider.request(.deleteUser) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204 {
                    completion(.success(Void()))
                } else {
                    completion(.failure(ApiError.parsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateUser(
        user: User,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        guard let user = loggedInUser else { return }
        
        var parameters: [String: Any] = [:]
        
        if let name = user.name {
            parameters["name"] = name
        }
        
        if let birthdate = user.birthdate {
            parameters["birthdate"] = birthdate.replacingOccurrences(of: " 00:00:00", with: "")
        }
        
        if let gender = user.gender {
            parameters["gender"] = gender
        }
        
        if let romance = user.preferenceRomance {
            parameters["preferenceRomance"] = romance
        }
        
        if let friendship = user.preferenceFriendship {
            parameters["preferenceFriendship"] = friendship
        }
        
        if let aboutMe = user.aboutMe {
            parameters["aboutMe"] = aboutMe
        }
        
        if let height = user.height {
            parameters["height"] = height
        }
        
        if let isOnline = user.isOnline {
            parameters["isOnline"] = isOnline
        }
        
        if let lastSeen = user.isUserLastSeenEnable {
            parameters["isUserLastSeenEnable"] = lastSeen
        }
        
        if let kids = user.preferenceKids {
            parameters["kids"] = kids
        }
        
        if let smoking = user.preferenceSmoking {
            parameters["smoking"] = smoking
        }
        
        if let distance = user.preferenceDistance {
            parameters["distance"] = distance
        }
        
        if let ageFrom = user.preferenceAgeFrom {
            parameters["ageFrom"] = ageFrom
        }
        
        if let ageTo = user.preferenceAgeTo {
            parameters["ageTo"] = ageTo
        }
        
        if let interestedActivityCategories = user.favouriteActivityCategories {
            parameters["favouriteActivityCategories"] = interestedActivityCategories.map { $0.id }
        }
        
        if let address = user.userAddress {
            parameters["address"] = ["address": address.address,
                                     "latitude": address.latitude,
                                     "longitude": address.longitude,
                                     "city": address.city,
                                     "state": address.state,
                                     "country": address.country,
                                     "pincode": address.pincode] as [String : Any]
        }
        
        if let notifications = user.notifications {
            parameters["notifications"] = notifications
        }
        
        userProvider.request(.updateUser(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode(ApiUserModel.self, from: response.data)
                    completion(.success(model.user))
                } catch let error {
                    print(error)
                    
                    if let model = try? JSONDecoder().decode(ApiErrorModel.self, from: response.data) {
                        completion(.failure(ApiError.custom(errorDescription: model.message)))
                    } else {
                        completion(.failure(ApiError.parsing))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateUserMedia(
        image: UIImage,
        position: Int,
        completion: @escaping (Result<UserProfileMedia, Error>) -> Void
    ) {
        userProvider.request(.updateUserMedia(image: image, position: position)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode(UserProfileMedia.self, from: response.data)
                    completion(.success(model))
                } catch let error {
                    print(error)
                    
                    if let model = try? JSONDecoder().decode(ApiErrorModel.self, from: response.data) {
                        completion(.failure(ApiError.custom(errorDescription: model.message)))
                    } else {
                        completion(.failure(ApiError.parsing))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
