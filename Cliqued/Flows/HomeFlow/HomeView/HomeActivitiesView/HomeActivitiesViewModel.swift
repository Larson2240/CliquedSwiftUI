//
//  HomeActivitiesViewModel.swift
//  Cliqued
//
//  Created by C211 on 18/01/23.
//

import SwiftUI

final class HomeActivitiesViewModel: ObservableObject {
    var dataReceivedAction: (() -> Void)?
    var likeDislikeAction: ((UserFollowing) -> Void)?
    
    var userMatches: [User] = []
    
    private let matchesWebService = MatchesWebService()
    private let userFollowingWebService = UserFollowingWebService()
    
    func callGetUserActivityAPI(id: String) {
        UIApplication.shared.showLoader()
        
        matchesWebService.getMatchesHome { [weak self] result in
            UIApplication.shared.hideLoader()
            
            switch result {
            case .success(let model):
                self?.userMatches = model
            case .failure(let error):
                if let error = error as? ApiError, let message = error.errorDescription {
                    UIApplication.shared.showAlertPopup(message: message)
                } else {
                    UIApplication.shared.showAlertPopup(message: error.localizedDescription)
                }
            }
            
            self?.dataReceivedAction?()
        }
    }
    
    func callLikeDislikeUserAPI(userID: Int, follow: Bool) {
        UIApplication.shared.showLoader()
        
        userFollowingWebService.callLikeDislikeUserAPI(userID: userID, follow: follow) { [weak self] result in
            UIApplication.shared.hideLoader()
            
            switch result {
            case .success(let model):
                self?.likeDislikeAction?(model)
            case .failure(let error):
                if let error = error as? ApiError, let message = error.errorDescription {
                    UIApplication.shared.showAlertPopup(message: message)
                } else {
                    UIApplication.shared.showAlertPopup(message: error.localizedDescription)
                }
            }
            
            self?.dataReceivedAction?()
        }
    }
}
