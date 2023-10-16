//
//  UserFollowingWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 16.10.2023.
//

import Foundation
import Moya

final class UserFollowingWebService {
    private let userFollowingProvider = MoyaProvider<UserFollowingProvider>()
    
    func getUserFollowers(completion: @escaping (Result<[User], Error>) -> Void) {
        userFollowingProvider.request(.getUserFollowers) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([User].self, from: response.data)
                    completion(.success(model))
                } catch {
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
    
    func callLikeDislikeUserAPI(
        userID: Int,
        follow: Bool,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        let parameters: [String: Any] = ["counterUser": "/api/users/\(userID)",
                                         "follow": follow]
        
        userFollowingProvider.request(.followUser(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([User].self, from: response.data)
                    completion(.success(model))
                } catch {
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
