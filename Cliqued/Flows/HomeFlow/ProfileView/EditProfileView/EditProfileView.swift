//
//  EditProfileView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 22.06.2023.
//

import SwiftUI
import SwiftUIPager
import SDWebImageSwiftUI
import StepSlider

struct EditProfileView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @StateObject var viewModel: ProfileViewModel
    @StateObject private var page: Page = .first()
    
    @State private var slider: CustomSlider?
    @State private var currentPage = 0
    @State private var editActivitiesViewPresented = false
    @State private var romanceViewPresented = false
    @State private var locationViewPresented = false
    @State private var kidsSelection = ""
    
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
                    
                    name
                    
                    aboutMe
                    
                    favoriteActivities
                    
                    lookingFor
                    
                    location
                    
                    height
                    
                    kids
                    
                    smoking
                    
                    distanceAndAge
                }
                .padding(.bottom, 50)
            }
            
            saveButton
        }
        .ignoresSafeArea(.container, edges: .bottom)
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
    
    private var name: some View {
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
    
    private var lookingFor: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Constants.label_lookingFor)
                    .font(.themeMedium(14))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            
            Button(action: { romanceViewPresented.toggle() }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    
                    HStack {
                        Text(viewModel.userDetails.lookingForIds)
                            .font(.themeBook(14))
                            .foregroundColor(.colorDarkGrey)
                        
                        Spacer()
                        
                        Image("ic_next_arrow")
                    }
                        .padding(.horizontal)
                }
            }
            .frame(height: 47)
        }
        .padding(.horizontal, 20)
    }
    
    private var location: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Constants.label_location)
                    .font(.themeMedium(14))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            
            Button(action: { locationViewPresented.toggle() }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    
                    HStack {
                        Text(configureLocation())
                            .font(.themeBook(14))
                            .foregroundColor(.colorDarkGrey)
                        
                        Spacer()
                        
                        Image("ic_locationprofileorange")
                    }
                        .padding(.horizontal)
                }
            }
            .frame(height: 47)
        }
        .padding(.horizontal, 20)
    }
    
    private var height: some View {
        VStack {
            HStack {
                Text("\(Constants.label_height) \(Constants.label_heightInCm)")
                    .font(.themeMedium(16))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                
                TextField(Constants.placeholder_height, text: $viewModel.userDetails.height)
                    .font(.themeBook(14))
                    .foregroundColor(.colorDarkGrey)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 12)
            }
            .frame(height: 47)
        }
        .padding(.horizontal, 20)
    }
    
    private var kids: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Constants.label_kids)
                    .font(.themeMedium(14))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            
            Menu {
                Button(action: { viewModel.kidsOptionPicked(option: Constants.label_titleYes) }) {
                    Text(Constants.label_titleYes)
                }
                
                Button(action: { viewModel.kidsOptionPicked(option: Constants.label_titleNo) }) {
                    Text(Constants.label_titleNo)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    
                    HStack {
                        Text(viewModel.userDetails.kids.isEmpty ? "No" : viewModel.userDetails.kids)
                            .font(.themeBook(14))
                            .padding(.horizontal, 12)
                        
                        Spacer()
                    }
                }
                .foregroundColor(.colorDarkGrey)
            }
            .frame(height: 47)
        }
        .padding(.horizontal, 20)
    }
    
    private var smoking: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Constants.label_smoking)
                    .font(.themeMedium(14))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            
            Menu {
                Button(action: { viewModel.smokingOptionPicked(option: Constants.label_titleYes) }) {
                    Text(Constants.label_titleYes)
                }
                
                Button(action: { viewModel.smokingOptionPicked(option: Constants.label_titleNo) }) {
                    Text(Constants.label_titleNo)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    
                    HStack {
                        Text(viewModel.userDetails.smoking.isEmpty ? "No" : viewModel.userDetails.smoking)
                            .font(.themeBook(14))
                            .padding(.horizontal, 12)
                        
                        Spacer()
                    }
                }
                .foregroundColor(.colorDarkGrey)
            }
            .frame(height: 47)
        }
        .padding(.horizontal, 20)
    }
    
    private var distanceAndAge: some View {
        VStack(spacing: 25) {
            distance
            
            age
        }
    }
    
    private var distance: some View {
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
            .accentColor(.theme)
            .frame(height: 60)
            .padding(.horizontal)
            
            separator
        }
    }
    
    private var age: some View {
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
            
            if let slider = slider {
                RangeSlider(slider: slider)
            }
        }
        .padding(.horizontal)
    }
    
    private var separator: some View {
        Color.gray.opacity(0.6)
            .frame(height: 0.5)
    }
    
    private var saveButton: some View {
        Button(action: {
            viewModel.saveAgePreferences(ageMinValue: slider?.lowHandle.currentValue ?? 45,
                                         ageMaxValue: slider?.highHandle.currentValue ?? 99)
            viewModel.save()
        }) {
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
            NavigationLink(destination: PickActivityView(isFromEditProfile: true,
                                                         activitiesFlowPresented: $editActivitiesViewPresented),
                           isActive: $editActivitiesViewPresented,
                           label: EmptyView.init)
            .isDetailLink(false)
            
            NavigationLink(destination: RelationshipView(isFromEditProfile: true),
                           isActive: $romanceViewPresented,
                           label: EmptyView.init)
            .isDetailLink(false)
            
            NavigationLink(destination: LocationView(selectedDistance: viewModel.userDetails.distancePreference,
                                                     isFromEditProfile: true),
                           isActive: $locationViewPresented,
                           label: EmptyView.init)
            .isDetailLink(false)
        }
    }
    
    private func onAppearConfig() {
        slider = CustomSlider(minBound: 45,
                              maxBound: 99,
                              lowValue: Double(viewModel.userDetails.startAge) ?? 45,
                              highValue: Double(viewModel.userDetails.endAge) ?? 99,
                              width: screenSize.width - 80)
        
        viewModel.successAction = {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func configureLocation() -> String {
        guard viewModel.userDetails.location.isEmpty == false else { return "'" }
        
        let locationData = viewModel.userDetails.location.first
        
        return "\(locationData?.address ?? ""), \(locationData?.city ?? ""), \(locationData?.state ?? ""), \(locationData?.country ?? ""), \(locationData?.pincode ?? "")"
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(viewModel: ProfileViewModel())
    }
}
