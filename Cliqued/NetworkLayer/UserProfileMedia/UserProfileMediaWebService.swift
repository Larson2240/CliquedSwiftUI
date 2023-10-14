//
//  UserProfileMediaWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import Foundation
import Moya

final class UserProfileMediaWebService {
    private let userProfileMediaProvider = MoyaProvider<UserProfileMediaProvider>(plugins: [VerbosePlugin()])
    
    func postUserMedia(
        image: UIImage,
        position: Int,
        completion: @escaping (Result<UserProfileMedia, Error>) -> Void
    ) {
        userProfileMediaProvider.request(.postUserMedia(image: image, position: position)) { result in
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
