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
        VStack(spacing: 20) {
            header
            
            ScrollView(showsIndicators: false) {
                imageContainer
                
                nameStack
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
            } else {
                placeholderImage
            }
            
            gradient
            
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
