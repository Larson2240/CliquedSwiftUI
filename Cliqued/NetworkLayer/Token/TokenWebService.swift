//
//  TokenWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import Foundation
import Moya

final class TokenWebService {
    private let tokenProvider = MoyaProvider<TokenProvider>()
    
    func getTwilioToken(
        userID: String,
        roomID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        tokenProvider.request(.getTwillioToken(userID: userID, roomID: roomID)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 || response.statusCode == 201 {
                    completion(.success(Void()))
                } else {
                    completion(.failure(ApiError.parsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendOTPForPassword(
        parameters: [String: Any],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        tokenProvider.request(.updateNotificationToken(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 || response.statusCode == 201 {
                    completion(.success(Void()))
                } else {
                    completion(.failure(ApiError.parsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
