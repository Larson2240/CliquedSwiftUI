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
    
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
    @StateObject var viewModel: ProfileViewModel
    @StateObject private var page: Page = .first()
    
    @State private var slider: CustomSlider?
    @State private var currentPage = 0
    @State private var editActivitiesViewPresented = false
    @State private var romanceViewPresented = false
    @State private var locationViewPresented = false
    @State private var kids = false
    @State private var smoking = false
    @State private var name = ""
    @State private var aboutMe = ""
    @State private var height = ""
    @State private var distancePreference = ""
    
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
                    
                    aboutMeStack
                    
                    favoriteActivities
                    
                    lookingFor
                    
                    location
                    
                    heightStack
                    
                    kidsStack
                    
                    smokingStack
                    
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
            if loggedInUser?.userProfileMedia != nil {
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
    
    @ViewBuilder
    private var pagerView: some View {
        if let userMedia = loggedInUser?.userProfileMedia {
            Pager(page: page, data: userMedia) { object in
                WebImage(url: URL(string: "https://api.cliqued.app/\(object.url)"))
                    .placeholder {
                        placeholderImage
                    }
                    .resizable()
                    .frame(width: screenSize.width, height: 300)
                    .onTapGesture {
                        viewModel.imageTapped(object)
                    }
                    .zIndex(0)
            }
            .onPageChanged {
                currentPage = $0
            }
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
                
                TextField(Constants.placeholder_name, text: $name)
                    .font(.themeBook(14))
                    .foregroundColor(.colorDarkGrey)
                    .padding(.horizontal, 12)
            }
            .frame(height: 47)
        }
        .padding(.horizontal, 20)
    }
    
    private var aboutMeStack: some View {
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
                         text: $aboutMe)
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
                    if let activities = loggedInUser?.favouriteActivityCategories {
                        ForEach(activities) { activity in
                            if activity.parentID == nil {
                                imageCell(activity)
                                    .cornerRadius(10)
                            }
                        }
                        .frame(width: 110)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 140)
            
            separator
        }
    }
    
    private func imageCell(_ activity: Activity) -> some View {
        ZStack {
            let cellWidth: CGFloat = 110
            let cellHeight: CGFloat = 140
            
            Image(activity.title + "_image")
                .resizable()
                .scaledToFill()
                .frame(width: cellWidth, height: cellHeight)
            
            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                Spacer()
                
                HStack {
                    Text(activity.title)
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
        if let media = loggedInUser?.userProfileMedia {
            PageIndicator(numPages: media.count, selectedIndex: $currentPage)
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
                        Text("\(loggedInUser?.preferenceRomance != nil ? Constants.btn_romance : "") \(loggedInUser?.preferenceRomance != nil && loggedInUser?.preferenceFriendship != nil ? "& " : "")\(loggedInUser?.preferenceFriendship != nil ? Constants.btn_friendship : "")")
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
    
    private var heightStack: some View {
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
                
                TextField(Constants.placeholder_height, text: $height)
                    .font(.themeBook(14))
                    .foregroundColor(.colorDarkGrey)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 12)
            }
            .frame(height: 47)
        }
        .padding(.horizontal, 20)
    }
    
    private var kidsStack: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Constants.label_kids)
                    .font(.themeMedium(14))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            
            Menu {
                Button(action: { kids = true }) {
                    Text(Constants.label_titleYes)
                }
                
                Button(action: { kids = false }) {
                    Text(Constants.label_titleNo)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    
                    HStack {
                        Text(kids ? Constants.label_titleYes : Constants.label_titleNo)
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
    
    private var smokingStack: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Constants.label_smoking)
                    .font(.themeMedium(14))
                    .foregroundColor(.theme)
                
                Spacer()
            }
            
            Menu {
                Button(action: { smoking = true }) {
                    Text(Constants.label_titleYes)
                }
                
                Button(action: { smoking = false }) {
                    Text(Constants.label_titleNo)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    
                    HStack {
                        Text(smoking ? Constants.label_titleYes : Constants.label_titleNo)
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
            
            StepSlider(selected: $distancePreference,
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
        Button(action: { save() }) {
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
            
            NavigationLink(destination: LocationView(isFromEditProfile: true),
                           isActive: $locationViewPresented,
                           label: EmptyView.init)
            .isDetailLink(false)
        }
    }
    
    private func save() {
        loggedInUser?.name = name
        loggedInUser?.aboutMe = aboutMe
        loggedInUser?.height = Int(height) ?? 0
        loggedInUser?.preferenceKids = kids
        loggedInUser?.preferenceSmoking = smoking
        loggedInUser?.preferenceDistance = Int(distancePreference.replacingOccurrences(of: "km", with: ""))
        loggedInUser?.preferenceAgeFrom = slider?.lowHandle.currentValue
        loggedInUser?.preferenceAgeTo = slider?.highHandle.currentValue
        
        viewModel.updateAPI {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func onAppearConfig() {
        slider = CustomSlider(minBound: 45,
                              maxBound: 99,
                              lowValue: Double(loggedInUser?.preferenceAgeFrom ?? 45),
                              highValue: Double(loggedInUser?.preferenceAgeTo ?? 99),
                              width: screenSize.width - 80)
        
        if let name = loggedInUser?.name {
            self.name = name
        }
        
        if let aboutMe = loggedInUser?.aboutMe {
            self.aboutMe = aboutMe
        }
        
        if let height = loggedInUser?.height {
            self.height = String(height)
        }
        
        if let distance = loggedInUser?.preferenceDistance {
            self.distancePreference = "\(distance)km"
        }
        
        if let kidsPreference = loggedInUser?.preferenceKids {
            kids = kidsPreference
        }
        
        if let smokingPreference = loggedInUser?.preferenceSmoking {
            smoking = smokingPreference
        }
    }
    
    private func configureLocation() -> String {
        guard let location = loggedInUser?.userAddress else { return "" }
        
        return "\(location.address), \(location.city), \(location.state), \(location.country), \(location.pincode)"
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(viewModel: ProfileViewModel())
    }
}
