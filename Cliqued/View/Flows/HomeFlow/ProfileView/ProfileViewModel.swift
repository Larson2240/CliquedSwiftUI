//
//  ProfileViewModel.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {
    struct UserDetails {
        var profileCollection = [UserProfileImages]()
        var name = ""
        var age = ""
        var locationDistance = ""
        var aboutMe = ""
        var favoriteActivity = [UserInterestedCategory]()
        var favoriteCategoryActivity = [UserInterestedCategory]()
        var lookingForIds = ""
        var location = [UserAddress]()
        var height = ""
        var kids = ""
        var smoking = ""
        var distancePreference = ""
        var startAge = ""
        var endAge = ""
    }
    
    @Published var userDetails = UserDetails()
    @Published var favoriteActivity = [UserInterestedCategory]()
    private let profileSetupType = ProfileSetupType()
    
    var objUserDetails: User?
    
    //MARK: Bind data on screen from the user object.
    func configureUser() {
        guard let userData = Constants.loggedInUser else { return }
        
        userDetails.name = userData.name ?? ""
        userDetails.age = "\(userData.age ?? 0)"
        
        let distanceInKm = String(format: "%.2f", userData.distanceInkm ?? 0)
        userDetails.locationDistance = "\(distanceInKm)"
        
        userDetails.aboutMe = userData.aboutme ?? ""
        userDetails.height = userData.height ?? ""
        
        userDetails.lookingForIds = userData.lookingForTitle ?? ""
        userDetails.smoking = userData.smokingSelectionId ?? ""
        userDetails.kids = userData.kidsSelectionId ?? ""
        userDetails.distancePreference = userData.distanceOptionId ?? ""
        
        userDetails.startAge = userData.ageStartId ?? ""
        userDetails.endAge = userData.ageEndId ?? ""
        
        if userData.userInterestedCategory?.count ?? 0 > 0 {
            if let favoriteActivity = userData.userInterestedCategory {
                userDetails.favoriteActivity = favoriteActivity
            }
        }
        if userData.userProfileImages?.count ?? 0 > 0 {
            if let profileImages = userData.userProfileImages {
                userDetails.profileCollection = profileImages
            }
        }
        if userData.userAddress?.count ?? 0 > 0 {
            if let userAddress = userData.userAddress {
                userDetails.location = userAddress
            }
        }
        
        //MARK: Managed multiple same category object in one category object
        var arrayOfActivityIds = [Int]()
        
        if userData.userInterestedCategory?.count ?? 0 > 0 {
            for interestedCategoryData in userData.userInterestedCategory ?? [] {
                if let activityId = interestedCategoryData.activityId {
                    arrayOfActivityIds.append(activityId)
                }
            }
        }
        
        userDetails.favoriteCategoryActivity.removeAll()
        
        for activityId in arrayOfActivityIds {
            if userDetails.favoriteCategoryActivity.contains(where: { $0.activityId == activityId }) == false {
                if let data = userDetails.favoriteCategoryActivity.filter({$0.activityId == activityId}).first {
                    userDetails.favoriteCategoryActivity.append(data)
                }
            }
        }
    }
    
    func url(for object: UserProfileImages, screenSize: CGSize) -> URL? {
        var mediaName = ""
        
        if object.mediaType == MediaType().image {
            mediaName = object.url ?? ""
        } else {
            mediaName = object.thumbnailUrl ?? ""
        }
        
        let strUrl = UrlProfileImage + mediaName
        let imageWidth = screenSize.width
        let imageHeight: CGFloat = 300
        let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth)&h=\(imageHeight)&zc=1&src=\(strUrl)"
        
        return URL(string: baseTimbThumb)
    }
    
    func manageSetupProfileNavigationFlow() {
        let strCount: String?
        if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
            let profile_setup_count = Int((Constants.loggedInUser?.profileSetupType)!)!
            strCount = "\(profile_setup_count)"
        } else {
            let profile_setup_count = Int((Constants.loggedInUser?.profileSetupType)!)! + 1
            strCount = "\(profile_setup_count)"
        }
        
        switch strCount {
        case profileSetupType.name:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NameView())
            
        case profileSetupType.birthdate:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: AgeView())
            
        case profileSetupType.gender:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: GenderView())
            
        case profileSetupType.relationship:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: RelationshipView(isFromEditProfile: false))
            
        case profileSetupType.category:
            let pickActivityView = PickActivityView(isFromEditProfile: false, arrayOfActivity: favoriteActivity)
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: pickActivityView)
            
        case profileSetupType.sub_category:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: PickSubActivityView(isFromEditProfile: false, categoryIds: "", arrayOfSubActivity: []))
            
        case profileSetupType.profile_images:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: SelectPicturesView(arrayOfProfileImage: [], isFromEditProfile: false))
            
        case profileSetupType.location:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: LocationView(isFromEditProfile: false, addressId: "", objAddress: nil))
            
        case profileSetupType.notification_enable:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NotificationsView())
            
        case profileSetupType.completed:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: StartExploringView())
        default:
            break
        }
    }
}
