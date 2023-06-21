//
//  ProfileView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 18.06.2023.
//

import SwiftUI
import SwiftUIPager
import SDWebImageSwiftUI

struct ProfileView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject private var page: Page = .first()
    
    @State private var currentPage = 0
    
    var body: some View {
        NavigationView {
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
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
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
                                      title: Constants.label_height,
                                      details: viewModel.userDetails.height == "0" ? "-" : viewModel.userDetails.height)
                    
                    ProfileCommonCell(imageName: "ic_kids",
                                      title: Constants.label_kids,
                                      details: viewModel.userDetails.kids.isEmpty ? "No" : viewModel.userDetails.kids)
                    
                    ProfileCommonCell(imageName: "ic_smoking",
                                      title: Constants.label_smoking,
                                      details: viewModel.userDetails.smoking.isEmpty ? "No" : viewModel.userDetails.smoking)
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
            } else {
                placeholderImage
            }
            
            gradient
            
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
            WebImage(url: viewModel.profileImageURL(for: object, screenSize: screenSize))
                .placeholder {
                    placeholderImage
                }
                .resizable()
                .frame(width: screenSize.width, height: 300)
        }
        .onPageChanged {
            currentPage = $0
        }
    }
    
    private var gradient: some View {
        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
            .allowsHitTesting(false)
    }
    
    private var topButtons: some View {
        HStack {
            Spacer()
            
            Button(action: {  }) {
                Image("ic_edit_category")
            }
            
            Button(action: {  }) {
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
        VStack(spacing: 12) {
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
        VStack(spacing: 12) {
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
    
    private var separator: some View {
        Color.colorLightGrey
            .frame(height: 0.7)
    }
    
    private var presentables: some View {
        ZStack {
            
        }
    }
    
    private func onAppearConfig() {
        viewModel.checkProfileCompletion()
        viewModel.configureUser()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
