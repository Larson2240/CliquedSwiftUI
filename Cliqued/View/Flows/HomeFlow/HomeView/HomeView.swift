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
    @State private var guideViewPresented = false
    @State private var uiTabBarController: UITabBarController?
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                content
            }
            .background(background)
            .onAppear { onAppearConfig() }
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
                
                Button(action: {
                    var transaction = Transaction(animation: nil)
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        guideViewPresented.toggle()
                    }
                }) {
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
                    if let image = activity.image.wrappedValue, let imageURL = URL(string: UrlActivityImage + image) {
                        imageCell(activity.wrappedValue, imageURL: imageURL)
                            .frame(maxHeight: 210)
                            .cornerRadius(15)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .ignoresSafeArea()
    }
    
    private func imageCell(_ activity: ActivityCategoryClass, imageURL: URL) -> some View {
        ZStack {
            let cellWidth = (screenSize.width - 40) / 2
            let cellHeight = cellWidth + (cellWidth * 0.2)
            
            WebImage(url: imageURL)
                .placeholder {
                    Image("placeholder_activity")
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
                    Text(activity.title ?? "")
                        .font(.themeMedium(14))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
            .padding(16)
        }
        .onTapGesture {
            
        }
    }
    
    private var guideView: some View {
        GuideView(isPresented: $guideViewPresented, isFromUserSwipeScreen: false, isFromActivitySwipeScreen: false, isFromActivitiesScreen: false)
            .introspectTabBarController { UITabBarController in
                UITabBarController.tabBar.isHidden = true
                uiTabBarController = UITabBarController
            }.onDisappear {
                uiTabBarController?.tabBar.isHidden = false
            }
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
