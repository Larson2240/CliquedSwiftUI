//
//  LocationView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 29.05.2023.
//

import SwiftUI
import StepSlider
import MapKit

struct LocationView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var onboardingViewModel = OnboardingViewModel.shared
    @StateObject private var locationViewModel = LocationViewModel()
    
    @State private var distanceValues: [String] = ["5km","10km","50km","100km","200km"]
    @State private var selectedDistance = "5km"
    @State private var notificationsViewPresented = false
    
    var isFromEditProfile: Bool
    var addressId: String
    var setlocationvc: String
    var objAddress: UserAddress?
    private let mediaType = MediaType()
    private let preferenceTypeIds = PreferenceTypeIds()
    
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
            
            title
            
            mapStack
            
            Spacer(minLength: 0)
            
            distanceStack
            
            Spacer(minLength: 0)
            
            continueButton
        }
    }
    
    private var header: some View {
        VStack(spacing: 20) {
            HeaderView(title: Constants.screenTitle_setYourLocation,
                       backButtonVisible: false)
            
            OnboardingProgressView(totalSteps: 9, currentStep: 8)
        }
    }
    
    private var title: some View {
        Text(Constants.label_setLocationScreenSubTitle)
            .font(.themeBold(20))
            .foregroundColor(.colorDarkGrey)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    private var mapStack: some View {
        let width = screenSize.width - 32
        
        ZStack {
            mapView
            
            currentLocationButton
        }
        .frame(width: width, height: width - 60)
    }
    
    private var mapView: some View {
        GeometryReader { proxy in
            Map(coordinateRegion: $locationViewModel.mapRegion, interactionModes: .all, annotationItems: locationViewModel.annotations) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    LocationAnnotationView(title: item.title)
                }
            }
            .gesture(TapGesture()
                .sequenced(before: DragGesture(
                    minimumDistance: 0,
                    coordinateSpace: .local))
                    .onEnded { value in
                        switch value {
                        case .second(_, let drag):
                            locationViewModel.convertTap(at: drag?.location ?? .zero, for: proxy.size)
                            
                        default:
                            break
                        }
                    })
            .highPriorityGesture(DragGesture(minimumDistance: 10))
            .cornerRadius(16)
        }
    }
    
    private var currentLocationButton: some View {
        VStack {
            Spacer()
            
            Button(action: { locationViewModel.determineCurrentLocation() }) {
                ZStack {
                    Color.white
                    
                    HStack {
                        Image("ic_current_location")
                        
                        Text(Constants.btn_goToCurrentLocation)
                            .foregroundColor(.colorDarkGrey)
                            .font(.themeMedium(17))
                    }
                }
                .cornerRadius(10)
                .frame(height: 60)
            }
        }
        .padding(16)
    }
    
    private var distanceStack: some View {
        VStack {
            Text(Constants.label_setLocationScreenDescription)
                .font(.themeBook(14))
                .foregroundColor(.colorDarkGrey)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
            
            slider
        }
        .padding(.horizontal)
    }
    
    private var slider: some View {
        StepSlider(selected: $selectedDistance, values: distanceValues) { value in
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
    }
    
    private var continueButton: some View {
        Button(action: { continueAction() }) {
            ZStack {
                Color.theme
                
                Text(Constants.btn_continue)
                    .font(.themeBold(20))
                    .foregroundColor(.colorWhite)
            }
        }
        .frame(height: 60)
        .cornerRadius(30)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
        .padding(.top, 16)
    }
    
    private var presentables: some View {
        NavigationLink(destination: NotificationsView(),
                       isActive: $notificationsViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func onAppearConfig() {
        locationViewModel.isFromEditProfile = isFromEditProfile
        locationViewModel.addressId = addressId
        
        setupDefaultDistantce()
        
        onboardingViewModel.nextAction = {
            if isFromEditProfile {
                presentationMode.wrappedValue.dismiss()
            } else {
                notificationsViewPresented.toggle()
            }
        }
    }
    
    private func continueAction() {
        if locationViewModel.addressDic.latitude != "" && locationViewModel.addressDic.longitude != "" && locationViewModel.addressDic.city != "" && locationViewModel.addressDic.state != "" {
            onboardingViewModel.userAddress.append(locationViewModel.addressDic)
            
            var arrayOfPreference = [PreferenceClass]()
            var arrayOfTypeOption = [TypeOptions]()
            arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == preferenceTypeIds.distance}) ?? []
            
            if arrayOfPreference.count > 0 {
                arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
                if arrayOfTypeOption.count > 0 {
                    var dict = DistanceParam()
                    guard let index = distanceValues.firstIndex(where: { $0 == selectedDistance }) else { return }
                    
                    dict.distancePreferenceId = arrayOfTypeOption[index].preferenceId?.description ?? ""
                    dict.distancePreferenceOptionId = arrayOfTypeOption[index].id?.description ?? ""
                    onboardingViewModel.distance = dict
                }
            }
            
            if !isFromEditProfile {
                onboardingViewModel.profileSetupType = ProfileSetupType().location
            } else {
                onboardingViewModel.profileSetupType = ProfileSetupType().completed
            }
            
            onboardingViewModel.callSignUpProcessAPI()
        } else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_validAddress)
        }
    }
    
    private func setupDefaultDistantce() {
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfTypeOption = [TypeOptions]()
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == preferenceTypeIds.distance}) ?? []
        if arrayOfPreference.count > 0 {
            arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
            if arrayOfTypeOption.count > 0 {
                var dict = DistanceParam()
                dict.distancePreferenceId = arrayOfTypeOption[0].preferenceId?.description ?? ""
                dict.distancePreferenceOptionId = arrayOfTypeOption[0].id?.description ?? ""
                onboardingViewModel.distance = dict
            }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(isFromEditProfile: false, addressId: "", setlocationvc: "")
    }
}
