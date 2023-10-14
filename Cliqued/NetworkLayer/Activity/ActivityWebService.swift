//
//  ActivityWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 29.09.2023.
//

import Foundation
import Moya

final class ActivityWebService {
    private let activityProvider = MoyaProvider<ActivityProvider>()
    
    func getActivityCategories(completion: @escaping (Result<[Activity], Error>) -> Void) {
        activityProvider.request(.getActivityCategories) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([Activity].self, from: response.data)
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
    
    func getUserActivities(completion: @escaping (Result<[UserActivityClass], Error>) -> Void) {
        activityProvider.request(.getUserActivities) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([UserActivityClass].self, from: response.data)
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
    
    func createActivity(
        parameters: [String: Any],
        completion: @escaping (Result<UserActivityClass, Error>) -> Void
    ) {
        activityProvider.request(.createActivity(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode(UserActivityClass.self, from: response.data)
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
    
    func updateActivity(activityID: String, parameters: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        activityProvider.request(.updateActivity(activityID: activityID, parameters: parameters)) { result in
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
    
    func deleteActivity(activityID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        activityProvider.request(.deleteActivity(id: activityID)) { result in
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
    
    func updateActivity(activityID: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        activityProvider.request(.updateActivityMedia(id: activityID, image: image)) { result in
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
    
    func updateActivityMedia(activityID: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        activityProvider.request(.updateActivityMedia(id: activityID, image: image)) { result in
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
