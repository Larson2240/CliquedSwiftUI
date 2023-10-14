//
//  HomeActivitiesViewModel.swift
//  Cliqued
//
//  Created by C211 on 18/01/23.
//

import Combine

final class HomeActivitiesViewModel: ObservableObject {
    private let matchesWebService = MatchesWebService()
    
    func callGetUserActivityAPI(id: String) {
        matchesWebService.getMatchesHome { result in
            
        }
    }
    
    func callLikeDislikeUserAPI(isShowLoader: Bool) {
        
    }
}
