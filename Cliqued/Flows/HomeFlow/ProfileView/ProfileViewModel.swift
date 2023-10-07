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
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
    let distanceValues = ["5km", "10km", "50km", "100km", "200km"]
    
    private let userWebService = UserWebService()
    
    func imageTapped(_ object: UserProfileMedia) {
        guard let media = loggedInUser?.userProfileMedia, let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        
//        if object.mediaType == mediaType.image {
            var images = [SKPhotoProtocol]()

            for i in 0..<media.count {
                let photo = SKPhoto.photoWithImageURL("https://cliqued.michal.es/\(media[i].url)")
                photo.shouldCachePhotoURLImage = true
                images.append(photo)
            }
        
            let browser = SKPhotoBrowser(photos: images)
            SKPhotoBrowserOptions.displayAction = false
            let index = media.firstIndex(where: { $0 == object })
            browser.initializePageIndex(index ?? 0)

            rootVC.present(browser, animated: true, completion: {})
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
    
    func updateAPI(completion: @escaping () -> Void) {
        guard let user = loggedInUser else { return }
        
        UIApplication.shared.showLoader()
        
        userWebService.updateUser(user: user) { _ in
            UIApplication.shared.hideLoader()
            completion()
        }
    }
    
    private func isOnlyCharacter(text: String) -> Bool {
        let characterRegEx = "[a-zA-Z\\s]+"
        let characterPred = NSPredicate(format:"SELF MATCHES %@", characterRegEx)
        return characterPred.evaluate(with: text)
    }
}
