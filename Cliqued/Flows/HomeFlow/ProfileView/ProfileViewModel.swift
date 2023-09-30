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
    struct UserDetails {
        var profileSetupType = ""
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
        var kidsPrefId = 0
        var kidsOptionId = 0
        var smoking = ""
        var smokingPrefId = 0
        var smokingOptionId = 0
        var distancePreference = ""
        var startAge = ""
        var endAge = ""
        var userPreferenceArray = [UserPreferences]()
        var distance: DistanceParam?
        var agePrefereneArray: AgePreferenceParam?
    }
    
    @Published var userDetails = UserDetails()
    @Published var profileCompleted = false
    
    private let profileSetupType = ProfileSetupType()
    private let mediaType = MediaType()
    private let preferenceTypeIds = PreferenceTypeIds()
    private let apiParams = ApiParams()
    private var arrayOfPreference = [PreferenceClass]()
    private var arrayOfSubType = [SubTypes]()
    private var arrayOfTypeOptionStartAge = [TypeOptions]()
    private var arrayOfTypeOptionEndAge = [TypeOptions]()
    
    var objUserDetails: User?
    var minSeekBarValue = ""
    var maxSeekBarValue = ""
    var successAction: (() -> Void)?
    
    let distanceValues = ["5km", "10km", "50km", "100km", "200km"]
    
    //MARK: Bind data on screen from the user object.
    func viewAppeared() {
        guard let userData = Constants.loggedInUser else { return }
        
        
        userDetails.favoriteCategoryActivity.removeAll()
        
        
        
        arrayOfPreference = Constants.getPreferenceData?.filter({ $0.typesOfPreference == preferenceTypeIds.age }) ?? []
        
        if arrayOfPreference.count > 0 {
            arrayOfSubType = arrayOfPreference[0].subTypes ?? []
            if arrayOfSubType.count > 0 {
                let subTypesData = arrayOfSubType.filter({ $0.typesOfPreference == preferenceTypeIds.age_start })
                arrayOfTypeOptionStartAge = subTypesData[0].typeOptions ?? []
                
                let subTypesDataEndAge = arrayOfSubType.filter({ $0.typesOfPreference == preferenceTypeIds.age_end })
                arrayOfTypeOptionEndAge = subTypesDataEndAge[0].typeOptions ?? []
            }
        }
    }
    
    func profileImageURL(for object: UserProfileImages, imageSize: CGSize) -> URL? {
        var mediaName = ""
        
        if object.mediaType == MediaType().image {
            mediaName = object.url ?? ""
        } else {
            mediaName = object.thumbnailUrl ?? ""
        }
        
        let strUrl = UrlProfileImage + mediaName
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth)&h=\(imageHeight)&zc=1&src=\(strUrl)"
        
        return URL(string: baseTimbThumb)
    }
    
    func activityImageURL(for object: UserInterestedCategory, size: CGSize) -> URL? {
        let img = object.activityCategoryImage ?? ""
        let strUrl = UrlActivityImage + img
        let baseTimbThumb = "\(URLBaseThumb)w=\(size.width * 3)&h=\(size.height * 3)&zc=1&src=\(strUrl)"
        return URL(string: baseTimbThumb)
    }
    
    func manageSetupProfileNavigationFlow() {
        let strCount: String?
        if let user = Constants.loggedInUser, user.profileSetupCompleted() {
            let profile_setup_count = (Constants.loggedInUser?.profileSetupType)!
            strCount = "\(profile_setup_count)"
        } else {
            let profile_setup_count = (Constants.loggedInUser?.profileSetupType)! + 1
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
            let pickActivityView = PickActivityView(isFromEditProfile: false, activitiesFlowPresented: .constant(false))
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: pickActivityView)
            
        case profileSetupType.sub_category:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: PickSubActivityView(isFromEditProfile: false, activitiesFlowPresented: .constant(false)))
            
        case profileSetupType.profile_images:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: SelectPicturesView(arrayOfProfileImage: [], isFromEditProfile: false))
            
        case profileSetupType.location:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: LocationView(isFromEditProfile: false))
            
        case profileSetupType.notification_enable:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NotificationsView())
            
        case profileSetupType.completed:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: StartExploringView())
        default:
            break
        }
    }
    
    func imageTapped(_ object: UserProfileImages) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        if object.mediaType == mediaType.image {
            var images = [SKPhotoProtocol]()
            
            for i in 0..<userDetails.profileCollection.count {
                guard userDetails.profileCollection[i].mediaType == mediaType.image else { continue }
                
                let photo = SKPhoto.photoWithImageURL(UrlProfileImage + (userDetails.profileCollection[i].url ?? ""))
                photo.shouldCachePhotoURLImage = true
                images.append(photo)
            }
            
            let browser = SKPhotoBrowser(photos: images)
            SKPhotoBrowserOptions.displayAction = false
            let index = userDetails.profileCollection.firstIndex(where: { $0 == object })
            browser.initializePageIndex(index ?? 0)
            
            rootVC.present(browser, animated: true, completion: {})
        } else {
            let videoURL = URL(string: UrlProfileImage + (object.url ?? ""))
            let player = AVPlayer(url: videoURL! as URL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            rootVC.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    func kidsOptionPicked(option: String) {
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfTypeOption = [TypeOptions]()
        
        arrayOfPreference = Constants.getPreferenceData?.filter { $0.typesOfPreference == preferenceTypeIds.kids } ?? []
        
        guard arrayOfPreference.count > 0 else { return }
        
        arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
        
        guard arrayOfTypeOption.count > 0 else { return }
        
        let subTypesData = arrayOfTypeOption.filter({$0.title == option})
        let prefId = subTypesData[0].preferenceId
        let optionId = subTypesData[0].id
        
        userDetails.kidsPrefId = prefId ?? 0
        userDetails.kidsOptionId = optionId ?? 0
        userDetails.kids = option
    }
    
    func smokingOptionPicked(option: String) {
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfTypeOption = [TypeOptions]()
        
        arrayOfPreference = Constants.getPreferenceData?.filter { $0.typesOfPreference == preferenceTypeIds.kids } ?? []
        
        guard arrayOfPreference.count > 0 else { return }
        
        arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
        
        guard arrayOfTypeOption.count > 0 else { return }
        
        let subTypesData = arrayOfTypeOption.filter({$0.title == option})
        let prefId = subTypesData[0].preferenceId
        let optionId = subTypesData[0].id
        
        userDetails.smokingPrefId = prefId ?? 0
        userDetails.smokingOptionId = optionId ?? 0
        userDetails.smoking = option
    }
    
    func saveAgePreferences(ageMinValue: Int, ageMaxValue: Int) {
        var startAgeId = ""
        var startAgePrefId = ""
        var endAgeId = ""
        var endAgePrefId = ""
        
        for mydata in arrayOfTypeOptionStartAge {
            if let strToNum1 = NumberFormatter().number(from: mydata.title ?? "") {
                let startAge = CGFloat(truncating: strToNum1)
                if startAge == CGFloat(ageMinValue) {
                    startAgeId = mydata.id?.description ?? ""
                    startAgePrefId = mydata.preferenceId?.description ?? ""
                }
            }
        }
        
        if arrayOfTypeOptionEndAge.count > 0 {
            for mydata in arrayOfTypeOptionEndAge {
                if let strToNum1 = NumberFormatter().number(from: mydata.title ?? "") {
                    let endAge = CGFloat(truncating: strToNum1)
                    if endAge == CGFloat(ageMaxValue) {
                        endAgeId = mydata.id?.description ?? ""
                        endAgePrefId = mydata.preferenceId?.description ?? ""
                    }
                }
            }
        }
        
        userDetails.agePrefereneArray = AgePreferenceParam(age_start_id: startAgeId,
                                                           age_start_pref_id: startAgePrefId,
                                                           age_end_id: endAgeId,
                                                           age_end_pref_id: endAgePrefId)
    }
    
    func save() {
        userDetails.profileSetupType = profileSetupType.completed
        
        let isValidName = isOnlyCharacter(text: userDetails.name)
        
        if isValidName {
            callSignUpProcessAPI()
        } else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_validName)
        }
    }
    
    private func isOnlyCharacter(text: String) -> Bool {
        let characterRegEx = "[a-zA-Z\\s]+"
        let characterPred = NSPredicate(format:"SELF MATCHES %@", characterRegEx)
        return characterPred.evaluate(with: text)
    }
}


// MARK: - Private methods
extension ProfileViewModel {
    private func callSignUpProcessAPI() {
        guard allValid() else { return }
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.profile_setup_type : userDetails.profileSetupType,
            apiParams.name : userDetails.name,
            apiParams.about_me : userDetails.aboutMe,
            apiParams.height : userDetails.height,
            apiParams.kids_preference_id : userDetails.kidsPrefId,
            apiParams.kids_option_id : userDetails.kidsOptionId,
            apiParams.smoking_preference_id : userDetails.smokingPrefId,
            apiParams.smoking_option_id : userDetails.smokingOptionId,
            apiParams.distance_pref : convertDistanceParamStructToString(),
            apiParams.age_pref : convertAgePreferenceParamStructToString(),
        ]
        
        guard Connectivity.isConnectedToInternet() else { return }
        
        UIApplication.shared.showLoader()
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.UpdateProfile, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            UIApplication.shared.hideLoader()
            
            if error != nil && response == nil {
                UIApplication.shared.showAlertPopup(message: message ?? "")
            } else {
                let json = response as? NSDictionary
                let status = json?[API_STATUS] as? Int
                let message = json?[API_MESSAGE] as? String
                
                if status == SUCCESS {
                    if let userArray = json?["user"] as? NSArray {
                        if userArray.count > 0 {
                            let dicUser = userArray[0] as! NSDictionary
                            let decoder = JSONDecoder()
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                let objUser = try decoder.decode(User.self, from: jsonData)
                                Constants.saveUser(user: objUser)
                                self.successAction?()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                } else {
                    UIApplication.shared.showAlertPopup(message: message ?? "")
                }
            }
        }
    }
    
    private func allValid() -> Bool {
        var result = false
        
        if userDetails.name.trimmingCharacters(in: .whitespaces).isEmpty {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_validName)
        } else if Int(userDetails.height) ?? 0 > 0 && Int(userDetails.height) ?? 0 < 100 {
            UIApplication.shared.showAlertPopup(message: Constants.alertMsg_validHeight)
        } else if Int(userDetails.height) ?? 0 > 220 {
            UIApplication.shared.showAlertPopup(message: Constants.alertMsg_validHeight)
        } else {
            result = true
        }
        
        return result
    }
    
    private func convertDistanceParamStructToString() -> String {
        guard let distance = userDetails.distance else { return "" }
        
        var optionlist = [String]()
        
        if !distance.distancePreferenceOptionId.isEmpty {
            let dict : NSMutableDictionary = [
                apiParams.distancePrefOptionId : distance.distancePreferenceOptionId,
                apiParams.distancePrefId : distance.distancePreferenceId
            ]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            optionlist.append(jsonstringstr!)
        }
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        return jsonstring!
    }
    
    //MARK: Convert User Address Struct to String
    private func convertAgePreferenceParamStructToString() -> String {
        guard let age = userDetails.agePrefereneArray else { return "" }
        
        var optionlist = [String]()
        
        if !age.age_start_id.isEmpty {
            let dict : NSMutableDictionary = [
                apiParams.ageStartId : age.age_start_id ,
                apiParams.ageStartPrefId : age.age_start_pref_id,
                apiParams.ageEndId : age.age_end_id,
                apiParams.ageEndPrefId : age.age_end_pref_id
            ]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            optionlist.append(jsonstringstr!)
        }
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        return jsonstring!
    }
}
