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
    
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
    @StateObject private var locationViewModel = LocationViewModel()
    
    @State private var distanceValues: [String] = ["5km", "10km", "50km", "100km", "200km"]
    @State private var selectedDistance = "5km"
    @State private var notificationsViewPresented = false
    
    var isFromEditProfile: Bool
    
    var body: some View {
        ZStack {
            content
            
            presentables
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(background)
        .navigationBarHidden(true)
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
                       backButtonVisible: isFromEditProfile,
                       backAction: { presentationMode.wrappedValue.dismiss() })
            
            if !isFromEditProfile {
                OnboardingProgressView(totalSteps: 9, currentStep: 8)
            }
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
            .animation(.default, value: locationViewModel.annotations.map { $0.id })
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
        .cornerRadius(30)
        .frame(height: 60)
        .padding(30)
    }
    
    private var presentables: some View {
        NavigationLink(destination: NotificationsView(),
                       isActive: $notificationsViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func continueAction() {
        if locationViewModel.latitude != 0 && locationViewModel.longitude != 0 && locationViewModel.city != "" && locationViewModel.state != "" {
            let userAddress = Address(address: locationViewModel.address,
                                      latitude: locationViewModel.latitude,
                                      longitude: locationViewModel.longitude,
                                      city: locationViewModel.city,
                                      state: locationViewModel.state,
                                      country: locationViewModel.country,
                                      pincode: locationViewModel.pincode)
            
            loggedInUser?.userAddress = userAddress
            loggedInUser?.preferenceDistance = Int(selectedDistance.replacingOccurrences(of: "km", with: ""))
            
            notificationsViewPresented.toggle()
        } else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_validAddress)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(isFromEditProfile: false)
    }
}
