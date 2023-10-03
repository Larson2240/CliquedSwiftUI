//
//  ProfileViewModel.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import SwiftUI
import SKPhotoBrowser
import AVKit.AVPlayerViewController

struct AgePreferenceParam {
    var age_start_id: String
    var age_start_pref_id: String
    var age_end_id: String
    var age_end_pref_id: String
}

final class ProfileViewModel: ObservableObject {
    var successAction: (() -> Void)?
    
    let distanceValues = ["5km", "10km", "50km", "100km", "200km"]
    
    func viewAppeared() {
        guard let user = Constants.loggedInUser else { return }
        
    }
    
    func imageTapped(_ object: UserProfileImages) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        
//        if object.mediaType == mediaType.image {
//            var images = [SKPhotoProtocol]()
//
//            for i in 0..<userDetails.profileCollection.count {
//                guard userDetails.profileCollection[i].mediaType == mediaType.image else { continue }
//
//                let photo = SKPhoto.photoWithImageURL(UrlProfileImage + (userDetails.profileCollection[i].url ?? ""))
//                photo.shouldCachePhotoURLImage = true
//                images.append(photo)
//            }
//
//            let browser = SKPhotoBrowser(photos: images)
//            SKPhotoBrowserOptions.displayAction = false
//            let index = userDetails.profileCollection.firstIndex(where: { $0 == object })
//            browser.initializePageIndex(index ?? 0)
//
//            rootVC.present(browser, animated: true, completion: {})
//        } else {
//            let videoURL = URL(string: UrlProfileImage + (object.url ?? ""))
//            let player = AVPlayer(url: videoURL! as URL)
//            let playerViewController = AVPlayerViewController()
//            playerViewController.player = player
//
//            rootVC.present(playerViewController, animated: true) {
//                playerViewController.player!.play()
//            }
//        }
    }
    
    func kidsOptionPicked(option: String) {
        
    }
    
    func smokingOptionPicked(option: String) {
        
    }
    
    func saveAgePreferences(ageMinValue: Int, ageMaxValue: Int) {
        
    }
    
    func save() {
//        let isValidName = isOnlyCharacter(text: userDetails.name)
//
//        if isValidName {
//            callSignUpProcessAPI()
//        } else {
//            UIApplication.shared.showAlertPopup(message: Constants.validMsg_validName)
//        }
    }
    
    private func isOnlyCharacter(text: String) -> Bool {
        let characterRegEx = "[a-zA-Z\\s]+"
        let characterPred = NSPredicate(format:"SELF MATCHES %@", characterRegEx)
        return characterPred.evaluate(with: text)
    }
}
