//
//  UserInterestedActivityWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import Foundation
import Moya

final class UserInterestedActivityWebService {
    private let userInterestedActivityProvider = MoyaProvider<UserInterestedActivityProvider>()
    
    func getUserInterestedActivities(completion: @escaping (Result<Void, Error>) -> Void) {
        userInterestedActivityProvider.request(.getUserInterestedActivities) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 || response.statusCode == 201 {
                    completion(.success(Void()))
                } else {
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
    
    func postUserInterestedActivity(parameters: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        userInterestedActivityProvider.request(.postUserInterestedActivity(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 || response.statusCode == 201 {
                    completion(.success(Void()))
                } else {
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
