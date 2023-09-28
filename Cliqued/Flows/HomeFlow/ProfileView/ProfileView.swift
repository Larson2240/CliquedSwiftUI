//
//  ProfileView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 18.06.2023.
//

import SwiftUI
import SwiftUIPager
import SDWebImageSwiftUI
import StepSlider

struct ProfileView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject private var page: Page = .first()
    
    @State private var slider: CustomSlider?
    @State private var currentPage = 0
    @State private var editProfileViewPresented = false
    @State private var settingsViewPresented = false
    
    var body: some View {
        ZStack {
            if viewModel.profileCompleted {
                content
            } else {
                completeProfileView
            }
            
            presentables
        }
        .background(background)
        .onAppear { onAppearConfig() }
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            imageContainer
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    aboutMe
                    
                    favoriteActivities
                    
                    ProfileCommonCell(imageName: "ic_lookingfor",
                                      title: Constants.label_lookingFor,
                                      details: viewModel.userDetails.lookingForIds)
                    
                    ProfileCommonCell(imageName: "ic_location_black",
                                      title: Constants.label_location,
                                      details: "\(viewModel.userDetails.location.first?.city ?? ""), \(viewModel.userDetails.location.first?.state ?? "")")
                    
                    ProfileCommonCell(imageName: "ic_height",
                                      title: "\(Constants.label_height) \(Constants.label_heightInCm)",
                                      details: viewModel.userDetails.height == "0" ? "-" : viewModel.userDetails.height)
                    
                    ProfileCommonCell(imageName: "ic_kids",
                                      title: Constants.label_kids,
                                      details: viewModel.userDetails.kids.isEmpty ? "No" : viewModel.userDetails.kids)
                    
                    ProfileCommonCell(imageName: "ic_smoking",
                                      title: Constants.label_smoking,
                                      details: viewModel.userDetails.smoking.isEmpty ? "No" : viewModel.userDetails.smoking)
                    
                    distanceStack
                    
                    ageStack
                    
                    editProfileButton
                }
                .padding(.vertical, 16)
                .padding(.bottom, 100)
            }
        }
        .ignoresSafeArea()
    }
    
    private var completeProfileView: some View {
        VStack(spacing: 16) {
            Text(Constants.validMsg_profileIncompleteMsg)
                .font(.themeMedium(14))
                .foregroundColor(.colorDarkGrey)
                .multilineTextAlignment(.center)
            
            Button(action: { viewModel.manageSetupProfileNavigationFlow() }) {
                ZStack {
                    Color.theme
                    
                    Text(Constants.btn_continue)
                        .font(.themeBold(20))
                        .foregroundColor(.colorWhite)
                }
            }
            .frame(height: 60)
            .cornerRadius(30)
        }
        .padding(30)
    }
    
    private var imageContainer: some View {
        ZStack {
            if viewModel.userDetails.profileCollection.count > 0 {
                pagerView
                
                gradient
            } else {
                placeholderImage
            }
            
            VStack {
                topButtons
                
                Spacer()
                
                pageIndicator
            }
            
            userDetailsStack
        }
        .frame(width: screenSize.width, height: 300)
    }
    
    private var pagerView: some View {
        Pager(page: page, data: viewModel.userDetails.profileCollection, id: \.self) { object in
            WebImage(url: viewModel.profileImageURL(for: object, imageSize: CGSize(width: screenSize.width, height: 300)))
                .placeholder {
                    placeholderImage
                }
                .resizable()
                .frame(width: screenSize.width, height: 300)
                .onTapGesture {
                    viewModel.imageTapped(object)
                }
        }
        .onPageChanged {
            currentPage = $0
        }
    }
    
    private var gradient: some View {
        VStack {
            Spacer()
            
            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                .allowsHitTesting(false)
                .frame(height: 130)
        }
    }
    
    private var topButtons: some View {
        HStack {
            Spacer()
            
            Button(action: { editProfileViewPresented.toggle() }) {
                Image("ic_edit_category")
            }
            
            Button(action: { settingsViewPresented.toggle() }) {
                Image("ic_setting_icon")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, safeAreaInsets.top + 12)
    }
    
    @ViewBuilder
    private var pageIndicator: some View {
        if viewModel.userDetails.profileCollection.count > 0 {
            PageIndicator(numPages: viewModel.userDetails.profileCollection.count, selectedIndex: $currentPage)
                .allowsHitTesting(false)
                .padding(.bottom)
        }
    }
    
    private var userDetailsStack: some View {
        VStack {
            Spacer()
            
            HStack {
                Text("\(viewModel.userDetails.name), \(viewModel.userDetails.age)")
                
                Spacer()
            }
            
            HStack {
                Text(viewModel.userDetails.location.first?.city ?? "")
                
                Spacer()
            }
        }
        .font(.themeBold(19))
        .foregroundColor(.white)
        .allowsHitTesting(false)
        .padding(.vertical, 25)
        .padding(.horizontal)
    }
    
    private var placeholderImage: some View {
        Image("placeholder_detailpage")
            .resizable()
            .frame(width: screenSize.width, height: 300)
    }
    
    private var aboutMe: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Constants.label_aboutMe)
                    .font(.themeMedium(16))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Text(viewModel.userDetails.aboutMe)
                    .font(.themeBook(14))
                    .foregroundColor(.colorDarkGrey)
                
                Spacer()
            }
            .padding(.horizontal)
            
            separator
        }
    }
    
    private var favoriteActivities: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Constants.label_myFavoriteActivities)
                    .font(.themeMedium(16))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach($viewModel.userDetails.favoriteCategoryActivity) { activity in
                        imageCell(activity.wrappedValue)
                            .cornerRadius(10)
                    }
                    .frame(width: 110)
                }
                .padding(.horizontal)
            }
            .frame(height: 140)
            
            separator
        }
    }
    
    private func imageCell(_ activity: UserInterestedCategory) -> some View {
        ZStack {
            let cellWidth: CGFloat = 110
            let cellHeight: CGFloat = 140
            
            WebImage(url: viewModel.activityImageURL(for: activity, size: CGSize(width: cellWidth, height: cellHeight)))
                .placeholder {
                    Image("placeholder_detailpage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: cellWidth, height: cellHeight)
                }
                .resizable()
                .scaledToFill()
                .frame(width: cellWidth, height: cellHeight)
            
            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                Spacer()
                
                HStack {
                    Text(activity.activityCategoryTitle ?? "")
                        .font(.themeMedium(10))
                        .foregroundColor(.white)
                        .padding(8)
                    
                    Spacer()
                }
            }
        }
    }
    
    private var distanceStack: some View {
        VStack(spacing: 16) {
            HStack {
                Image("ic_distance")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(Constants.label_distancePreference)
                    .font(.themeMedium(14))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            .padding(.horizontal)
            
            StepSlider(selected: $viewModel.userDetails.distancePreference,
                       values: viewModel.distanceValues) { value in
                Text(value)
                    .foregroundColor(.colorDarkGrey)
            } thumbLabels: { value in
                ZStack {
                    Color.theme
                        .ignoresSafeArea()
                    
                    Text(value)
                        .foregroundColor(.white)
                }
            } accessibilityLabels: { value in
                Text(value)
            }
            .allowsHitTesting(false)
            .accentColor(.theme)
            .frame(height: 60)
            .padding(.horizontal)
            
            separator
        }
    }
    
    private var ageStack: some View {
        VStack(spacing: 30) {
            HStack {
                Image("ic_age")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(Constants.label_agePreference)
                    .font(.themeMedium(14))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            .padding(.horizontal)
            
            if let slider = slider {
                RangeSlider(slider: slider)
                    .allowsHitTesting(false)
            }
            
            separator
                .padding(.top)
        }
    }
    
    private var separator: some View {
        Color.gray.opacity(0.6)
            .frame(height: 0.5)
    }
    
    private var editProfileButton: some View {
        Button(action: { editProfileViewPresented.toggle() }) {
            ZStack {
                Color.theme
                
                Text(Constants.btn_editProfile)
                    .font(.themeBold(20))
                    .foregroundColor(.colorWhite)
            }
        }
        .frame(height: 50)
        .cornerRadius(30)
        .padding(.top)
        .padding(.horizontal, 30)
    }
    
    private var presentables: some View {
        ZStack {
            NavigationLink(destination: EditProfileView(viewModel: viewModel),
                           isActive: $editProfileViewPresented,
                           label: EmptyView.init)
            .isDetailLink(false)
            
            NavigationLink(destination: SettingsView(),
                           isActive: $settingsViewPresented,
                           label: EmptyView.init)
            .isDetailLink(false)
        }
    }
    
    private func onAppearConfig() {
        viewModel.viewAppeared()
        
        slider = CustomSlider(minBound: 45,
                              maxBound: 99,
                              lowValue: Double(viewModel.userDetails.startAge) ?? 45,
                              highValue: Double(viewModel.userDetails.endAge) ?? 99,
                              width: screenSize.width - 80)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
