//
//  EditProfileView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 22.06.2023.
//

import SwiftUI
import SwiftUIPager
import SDWebImageSwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @StateObject var viewModel: ProfileViewModel
    @StateObject private var page: Page = .first()
    
    @State private var slider: CustomSlider?
    @State private var currentPage = 0
    @State private var editActivitiesViewPresented = false
    
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
        VStack(spacing: 25) {
            header
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    imageContainer
                    
                    nameStack
                    
                    aboutMe
                    
                    favoriteActivities
                }
            }
            
            saveButton
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var header: some View {
        HeaderView(title: Constants.screenTitle_editProfile,
                   backButtonVisible: true,
                   backAction: { presentationMode.wrappedValue.dismiss() })
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
                editImagesButton
                
                Spacer()
                
                pageIndicator
            }
        }
        .cornerRadius(25)
        .frame(width: screenSize.width - 40, height: 230)
        .padding(.horizontal, 20)
    }
    
    private var pagerView: some View {
        Pager(page: page, data: viewModel.userDetails.profileCollection, id: \.self) { object in
            WebImage(url: viewModel.profileImageURL(for: object, imageSize: CGSize(width: screenSize.width - 40, height: 230)))
                .placeholder {
                    placeholderImage
                }
                .resizable()
                .frame(width: screenSize.width - 40, height: 230)
                .onTapGesture {
                    viewModel.imageTapped(object)
                }
        }
        .onPageChanged {
            currentPage = $0
        }
    }
    
    private var nameStack: some View {
        VStack {
            HStack {
                Text(Constants.label_name)
                    .font(.themeMedium(16))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                
                TextField(Constants.placeholder_name, text: $viewModel.userDetails.name)
                    .font(.themeBook(14))
                    .foregroundColor(.colorDarkGrey)
                    .padding(.horizontal, 12)
            }
            .frame(height: 47)
        }
        .padding(.horizontal, 20)
    }
    
    private var aboutMe: some View {
        VStack {
            HStack {
                Text(Constants.label_aboutMe)
                    .font(.themeMedium(16))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                
                TextView(placeholder: Constants.placeholder_activityDescription,
                         text: $viewModel.userDetails.aboutMe)
                .padding(.horizontal, 8)
            }
            .font(.themeBook(14))
            .frame(height: 160)
        }
        .padding(.horizontal, 20)
    }
    
    private var favoriteActivities: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Constants.label_myFavoriteActivities)
                    .font(.themeMedium(16))
                    .foregroundColor(.theme)
                
                Spacer()
                
                Button(action: { editActivitiesViewPresented.toggle() }) {
                    Image("ic_edit_category")
                }
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
    
    private var placeholderImage: some View {
        Image("placeholder_detailpage")
            .resizable()
            .frame(width: screenSize.width - 40, height: 230)
    }
    
    private var gradient: some View {
        VStack {
            Spacer()
            
            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                .allowsHitTesting(false)
                .frame(height: 100)
        }
    }
    
    private var editImagesButton: some View {
        HStack {
            Spacer()
            
            Button(action: {  }) {
                Image("ic_editprofileimage")
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var pageIndicator: some View {
        if viewModel.userDetails.profileCollection.count > 0 {
            PageIndicator(numPages: viewModel.userDetails.profileCollection.count, selectedIndex: $currentPage)
                .allowsHitTesting(false)
                .padding(.bottom)
        }
    }
    
    private var separator: some View {
        Color.gray.opacity(0.6)
            .frame(height: 0.5)
    }
    
    private var saveButton: some View {
        Button(action: {  }) {
            ZStack {
                Color.theme
                
                Text(Constants.btn_save)
                    .font(.themeBold(20))
                    .foregroundColor(.colorWhite)
            }
        }
        .frame(height: 50)
        .cornerRadius(30)
        .padding(.horizontal, 30)
        .padding(.bottom, safeAreaInsets.bottom == 0 ? 16 : safeAreaInsets.bottom)
    }
    
    private var presentables: some View {
        ZStack {
            NavigationLink(destination: PickActivityView(isFromEditProfile: true, arrayOfActivity: viewModel.userDetails.favoriteActivity, activitiesFlowPresented: $editActivitiesViewPresented),
                           isActive: $editActivitiesViewPresented,
                           label: EmptyView.init)
            .isDetailLink(false)
        }
    }
    
    private func onAppearConfig() {
        
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(viewModel: ProfileViewModel())
    }
}
