//
//  SelectPicturesView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 28.05.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct SelectPicturesView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var onboardingViewModel = OnboardingViewModel.shared
    @StateObject private var picturesViewModel = SelectPicturesViewModel()
    
    @State private var locationViewPresented = false
    
    var arrayOfProfileImage: [UserProfileImages]
    var isFromEditProfile: Bool
    
    private let mediaType = MediaType()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                content
                
                presentables
            }
            .background(background)
            .onAppear { onAppearConfig() }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            header
            
            description
            
            imagesStack
            
            continueButton
        }
    }
    
    private var header: some View {
        VStack(spacing: 20) {
            HeaderView(title: Constants.screenTitle_selectPictures,
                       backButtonVisible: false)
            
            OnboardingProgressView(totalSteps: 9, currentStep: 7)
        }
    }
    
    private var description: some View {
        VStack(spacing: 12) {
            Text(Constants.label_selectPictureScreenTitle)
                .font(.themeBold(20))
            
            Text(Constants.label_selectPictureScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.top, 40)
        .padding(.horizontal)
    }
    
    private var imagesStack: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(picturesViewModel.arrayOfSelectedImages) { imageData in
                    imageCell(from: imageData)
                }
                
                addButton
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
    
    @ViewBuilder
    private var addButton: some View {
        let width = (screenSize.width - 15) / 3
        
        ZStack {
            Color(hex: "#E7E6E6")
                .frame(width: width - 20, height: width * 1.25)
                .cornerRadius(10)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Image("ic_add_image")
                }
            }
        }
        .frame(width: width, height: width * 1.3)
        .onTapGesture {
            picturesViewModel.openTLPhotoPicker()
        }
    }
    
    @ViewBuilder
    private func imageCell(from imageData: ProfileMedia) -> some View {
        let width = (screenSize.width - 15) / 3
        
        ZStack {
            if imageData.serverURL == nil, let localImage = imageData.image {
                Image(uiImage: localImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width - 20, height: width * 1.25)
                    .cornerRadius(10)
            } else if let imageURL = imageData.serverURL {
                WebImage(url: imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width - 20, height: width * 1.25)
                    .cornerRadius(10)
            }
            
            VStack {
                HStack {
                    Image("ic_cancel_img")
                        .onTapGesture {
                            picturesViewModel.removeImageTapped(with: imageData)
                        }
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .frame(width: width, height: width * 1.3)
    }
    
    private var continueButton: some View {
        Button(action: { continueAction() }) {
            ZStack {
                Color.theme
                
                Text(Constants.btn_continue)
                    .font(.themeBold(20))
                    .foregroundColor(.colorWhite)
            }
        }
        .frame(height: 60)
        .cornerRadius(30)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
        .padding(.top, 16)
    }
    
    private var presentables: some View {
        NavigationLink(destination: LocationView(isFromEditProfile: false, addressId: "", setlocationvc: "", objAddress: nil),
                       isActive: $locationViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func onAppearConfig() {
        onboardingViewModel.nextAction = {
            if isFromEditProfile {
                presentationMode.wrappedValue.dismiss()
            } else {
                onboardingViewModel.profileImages.removeAll()
                onboardingViewModel.thumbnails.removeAll()
                locationViewPresented.toggle()
            }
        }
        
        if isFromEditProfile {
            setupProfileImageCollection()
        }
    }
    
    private func continueAction() {
        onboardingViewModel.profileImages.removeAll()
        onboardingViewModel.thumbnails.removeAll()
        
        if !isFromEditProfile {
            for profileData in picturesViewModel.arrayOfSelectedImages {
                if profileData.mediaType == 0 {
                    onboardingViewModel.profileImages.append(profileData.image ?? UIImage())
                    onboardingViewModel.thumbnails.append(profileData.image ?? UIImage())
                } else if profileData.mediaType == 1 {
                    onboardingViewModel.profileImages.append(profileData.videoURL ?? URL.self)
                    onboardingViewModel.thumbnails.append(profileData.thumbnail ?? UIImage())
                }
            }
            
            //Check array count
            if onboardingViewModel.profileImages.count > 1 {
                //Check at least one image is selected or not.
                let isImageContain = picturesViewModel.arrayOfSelectedImages.contains(where: { $0.mediaType == 0 })
                
                if isImageContain {
                    onboardingViewModel.profileSetupType = ProfileSetupType().profile_images
                    onboardingViewModel.callSignUpProcessAPI()
                } else {
                    UIApplication.shared.showAlertPopup(message: Constants.validMsg_selectImage)
                }
            } else {
                UIApplication.shared.showAlertPopup(message: Constants.validMsg_selectPicture)
            }
        } else {
            if picturesViewModel.arrayOfSelectedImages.count > 1 {
                for profileData in picturesViewModel.arrayOfEditedImages {
                    if profileData.mediaType == 0 {
                        onboardingViewModel.profileImages.append(profileData.image ?? UIImage())
                        onboardingViewModel.thumbnails.append(profileData.image ?? UIImage())
                    } else if profileData.mediaType == 1 {
                        onboardingViewModel.profileImages.append(profileData.videoURL ?? URL.self)
                        onboardingViewModel.thumbnails.append(profileData.thumbnail ?? UIImage())
                    }
                }
                
                //Check at least one image is selected or not.
                let isImageContain = picturesViewModel.arrayOfSelectedImages.contains(where: { $0.mediaType == 0 })
                if isImageContain {
                    onboardingViewModel.profileSetupType = ProfileSetupType().completed
                    onboardingViewModel.deletedImageIds = picturesViewModel.arrayOfDeletedImageIds.map({ String($0) }).joined(separator: ", ")
                    
                    onboardingViewModel.callSignUpProcessAPI()
                } else {
                    UIApplication.shared.showAlertPopup(message: Constants.validMsg_selectImage)
                }
            } else {
                UIApplication.shared.showAlertPopup(message: Constants.validMsg_selectPicture)
            }
        }
    }
    
    private func setupProfileImageCollection() {
        for imagesData in arrayOfProfileImage {
            if imagesData.mediaType == mediaType.image {
                let strUrl = UrlProfileImage + imagesData.url!
                let url = URL(string: strUrl)
                
                if let imgUrl = url {
                    var dic = ProfileMedia()
                    dic.image = nil
                    dic.mediaType = 0
                    dic.thumbnail = nil
                    dic.videoURL = nil
                    dic.serverURL = imgUrl
                    dic.serverImageId = imagesData.id
                    picturesViewModel.arrayOfSelectedImages.append(dic)
                }
            } else {
                let strUrl = UrlProfileImage + imagesData.thumbnailUrl!
                let strVideoUrl = UrlProfileImage + imagesData.url!
                let videoURL = URL(string: strVideoUrl)
                let url = URL(string: strUrl)
                
                if let imgUrl = url {
                    var dic = ProfileMedia()
                    dic.image = nil
                    dic.mediaType = 1
                    dic.thumbnail = nil
                    dic.videoURL = videoURL
                    dic.serverURL = imgUrl
                    dic.serverImageId = imagesData.id
                    
                    picturesViewModel.arrayOfSelectedImages.append(dic)
                }
            }
        }
    }
}

struct SelectPicturesView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPicturesView(arrayOfProfileImage: [], isFromEditProfile: false)
    }
}
