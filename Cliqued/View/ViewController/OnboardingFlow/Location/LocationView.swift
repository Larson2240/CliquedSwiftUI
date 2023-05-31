//
//  LocationView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 29.05.2023.
//

import SwiftUI
import StepSlider

struct LocationView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel.shared
    
    private let values = ["5km","10km","50km","100km","200km"]
    @State private var selectedValue = "5km"
    @State private var locationViewPresented = false
    
    var isFromEditProfile: Bool
    var addressId: String
    var setlocationvc: String
    var objAddress: UserAddress?
    private let mediaType = MediaType()
    
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
            
            LocationMapView(objAddress: objAddress)
            
            Spacer()
            
            distanceStack
            
            Spacer()
            
            continueButton
        }
    }
    
    private var background: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(width: screenSize.width, height: screenSize.height)
    }
    
    private var header: some View {
        HeaderView(title: Constants.screenTitle_setYourLocation,
                   backButtonVisible: false)
    }
    
    private var title: some View {
        Text(Constants.label_setLocationScreenSubTitle)
            .font(.themeBold(20))
            .foregroundColor(.colorDarkGrey)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .padding(.top, 40)
            .padding(.horizontal)
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
        StepSlider(selected: $selectedValue, values: values) { value in
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
        ZStack {
            
        }
    }
    
    private func onAppearConfig() {
        onboardingViewModel.nextAction = {
            
        }
    }
    
    private func continueAction() {
        
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(isFromEditProfile: false, addressId: "", setlocationvc: "")
    }
}
