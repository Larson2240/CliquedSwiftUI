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
            imageContainer
            
            ScrollView {
                
            }
        }
        .ignoresSafeArea()
    }
    
    private var imageContainer: some View {
        ZStack {
            pagerView
            
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
            WebImage(url: viewModel.url(for: object, screenSize: screenSize))
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
    
    private var presentables: some View {
        ZStack {
            
        }
    }
    
    private func onAppearConfig() {
        viewModel.configureUser()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
