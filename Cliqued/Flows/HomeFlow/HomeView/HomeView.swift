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
    
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
    @State private var selectedCategory: Activity?
    @State private var guideViewPresented = false
    @State private var activitiesViewPresented = false
    @State private var uiTabBarController: UITabBarController?
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            content
            
            presentables
        }
        .background(background)
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            header
            
            activitiesStack
            
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
                if let user = loggedInUser, let activities = user.favouriteActivityCategories {
                    ForEach(activities) { activity in
                        if activity.parentID == nil {
                            imageCell(activity)
                                .frame(maxHeight: 210)
                                .cornerRadius(15)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .ignoresSafeArea()
    }
    
    private func imageCell(_ activity: Activity) -> some View {
        ZStack {
            let cellWidth = (screenSize.width - 40) / 2
            let cellHeight = cellWidth + (cellWidth * 0.2)
            
            Image(activity.title + "_image")
                .resizable()
                .scaledToFill()
                .frame(width: cellWidth, height: cellHeight)
            
            gradient
            
            VStack {
                Spacer()
                
                HStack {
                    Text(activity.title)
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
    
    private var presentables: some View {
        NavigationLink(destination: ActivitiesViewRepresentable().ignoresSafeArea(),
                       isActive: $activitiesViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
