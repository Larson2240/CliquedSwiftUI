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
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @StateObject private var picturesViewModel = SelectPicturesViewModel()
    
    @State private var locationViewPresented = false
    
    var arrayOfProfileImage: [UserProfileImages]
    var isFromEditProfile: Bool
    
    private let mediaType = MediaType()
    private let userWebService = UserWebService()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            content
            
            presentables
        }
        .background(background)
        .onAppear { onAppearConfig() }
        .navigationBarHidden(true)
    }
    
    private var content: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                
                description
                
                imagesStack
                    .ignoresSafeArea()
            }
            
            continueButton
                .ignoresSafeArea()
        }
    }
    
    private var header: some View {
        VStack(spacing: 20) {
            HeaderView(title: Constants.screenTitle_selectPictures,
                       backButtonVisible: false,
                       backAction: {})
            
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
        VStack {
            Spacer()
            
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
            .padding(.bottom, safeAreaInsets.bottom == 0 ? 16 : safeAreaInsets.bottom)
        }
    }
    
    private var presentables: some View {
        NavigationLink(destination: LocationView(isFromEditProfile: false),
                       isActive: $locationViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func onAppearConfig() {
        if isFromEditProfile {
            setupProfileImageCollection()
        }
    }
    
    private func continueAction() {
        guard var user = Constants.loggedInUser else { return }
        
        guard picturesViewModel.arrayOfSelectedImages.isEmpty == false else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_selectPicture)
            return
        }
        
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        UIApplication.shared.showLoader()
        
        for (i, media) in picturesViewModel.arrayOfSelectedImages.enumerated() {
            guard let image = media.image else { continue }
            
            dispatchGroup.enter()
            
            userWebService.updateUserMedia(image: image, position: i) { result in
                switch result {
                case .success(let media):
                    guard user.userProfileMedia?.contains(media) == false else { return }
                    
                    user.userProfileMedia?.append(media)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            Constants.saveUser(user: user)
            UIApplication.shared.hideLoader()
            locationViewPresented.toggle()
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
