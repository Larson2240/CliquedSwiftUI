//
//  HomeView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 08.06.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
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
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            header
            
            activitiesStack
        }
    }
    
    private var header: some View {
        ZStack {
            Image("ic_header_logo")
            
            HStack {
                Spacer()
                
                Button(action: {  }) {
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
    
    private var presentables: some View {
        ZStack {
            
        }
    }
    
    private func onAppearConfig() {
        viewModel.callGetPreferenceDataAPI()
        viewModel.callGetUserInterestedCategoryAPI()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
