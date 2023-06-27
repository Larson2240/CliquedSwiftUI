//
//  HomeView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 08.06.2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Introspect

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var selectedCategory: ActivityCategoryClass?
    @State private var guideViewPresented = false
    @State private var activitiesViewPresented = false
    @State private var uiTabBarController: UITabBarController?
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                content
                
                presentables
            }
            .background(background)
            .onAppear { onAppearConfig() }
            .onChange(of: activitiesViewPresented) { newValue in
                toggleTabBar(isHidden: newValue)
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            header
            
            if viewModel.profileCompleted {
                activitiesStack
            } else {
                completeProfileView
            }
            
            if guideViewPresented {
                guideView
            }
        }
    }
    
    private var header: some View {
        ZStack {
            Image("ic_header_logo")
            
            HStack {
                Spacer()
                
                Button(action: { guideViewPresented.toggle() }) {
                    Image("ic_explanationicon")
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var activitiesStack: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach($viewModel.arrayOfHomeCategory) { activity in
                    imageCell(activity.wrappedValue)
                        .frame(maxHeight: 210)
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .ignoresSafeArea()
    }
    
    private func imageCell(_ activity: ActivityCategoryClass) -> some View {
        ZStack {
            let cellWidth = (screenSize.width - 40) / 2
            let cellHeight = cellWidth + (cellWidth * 0.2)
            
            WebImage(url: viewModel.imageURL(for: activity, imageSize: CGSize(width: cellWidth, height: cellHeight)))
                .placeholder {
                    Image("placeholder_activity")
                        .resizable()
                        .scaledToFill()
                        .frame(width: cellWidth, height: cellHeight)
                }
                .resizable()
                .scaledToFill()
                .frame(width: cellWidth, height: cellHeight)
            
            gradient
            
            VStack {
                Spacer()
                
                HStack {
                    Text(activity.title ?? "")
                        .font(.themeMedium(14))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
            .padding(16)
        }
        .onTapGesture {
            selectedCategory = activity
            activitiesViewPresented.toggle()
        }
    }
    
    private var gradient: some View {
        VStack {
            Spacer()
            
            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                .allowsHitTesting(false)
                .frame(height: 100)
        }
    }
    
    private var guideView: some View {
        GuideView(isPresented: $guideViewPresented, isFromUserSwipeScreen: false, isFromActivitySwipeScreen: false, isFromActivitiesScreen: false)
            .introspectTabBarController { UITabBarController in
                UITabBarController.tabBar.isHidden = true
                uiTabBarController = UITabBarController
            }
            .onDisappear {
                uiTabBarController?.tabBar.isHidden = false
            }
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
    
    private var presentables: some View {
        NavigationLink(destination: HomeActivitiesView(category: selectedCategory),
                       isActive: $activitiesViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func onAppearConfig() {
        viewModel.checkProfileCompletion()
        viewModel.callGetPreferenceDataAPI()
        viewModel.callGetUserInterestedCategoryAPI()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
