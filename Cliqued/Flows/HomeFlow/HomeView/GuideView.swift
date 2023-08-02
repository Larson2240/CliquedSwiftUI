//
//  GuideView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 10.06.2023.
//

import SwiftUI

struct GuideView: View {
    @State private var currentIndex = 0
    @State private var arrayOfTutorial = [String]()
    
    @Binding var isPresented: Bool
    
    var isFromUserSwipeScreen: Bool
    var isFromActivitySwipeScreen: Bool
    var isFromActivitiesScreen: Bool
    
    private let arrayOfTabImages = ["hometab","hometabselected","activitytab","addactivity","editactivity","interestedcount","startdiscovery","chattab","profiletab"]
    private let arrayOfActivitiesTabImages = ["addactivity","editactivity","interestedcount","startdiscovery","chattab","profiletab"]
    private let arrayOfUserSwipeImages = ["userswipe","userinfo","userundo","userlike","userdontwantmeet"]
    private let arrayOfActivitySwipeImages = ["activityswipe","activityinfo","activitylike","activitydontwantmeet"]
    
    //Arrays for scale 2 devices
    private let arrayOfTabImagesScale2 = ["scl_hometab","scl_hometabselected","scl_activitytab","scl_addactivity","scl_editactivity","scl_interestedcount","scl_startdiscovery","scl_chattab","scl_profiletab"]
    private let arrayOfActivitiesTabImagesScale2 = ["scl_addactivity","scl_editactivity","scl_interestedcount","scl_startdiscovery","scl_chattab","scl_profiletab"]
    private let arrayOfUserSwipeImagesScale2 = ["scl_userswipe","scl_userinfo","scl_userundo","scl_userlike","scl_userdontwantmeet"]
    private let arrayOfActivitySwipeImagesScale2 = ["scl_activityswipe","scl_activityinfo","scl_activitylike","scl_activitydontwantmeet"]
    
    var body: some View {
        ZStack {
            content
        }
        .onAppear { configureImages() }
        .navigationBarHidden(true)
        .onTapGesture {
            guard !arrayOfTutorial.isEmpty else { return }
            
            if currentIndex + 1 < arrayOfTutorial.count {
                currentIndex += 1
            } else {
                isPresented.toggle()
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if arrayOfTutorial.isEmpty {
            EmptyView()
        } else {
            Image(imageNameConfig())
                .resizable()
                .scaledToFill()
                .frame(width: screenSize.width, height: screenSize.height)
                .ignoresSafeArea()
        }
    }
    
    private func configureImages() {
        if UIDevice.current.hasNotch {
            if isFromUserSwipeScreen {
                arrayOfTutorial = arrayOfUserSwipeImages
            } else if isFromActivitySwipeScreen {
                arrayOfTutorial = arrayOfActivitySwipeImages
            } else if isFromActivitiesScreen {
                arrayOfTutorial = arrayOfActivitiesTabImages
            } else {
                arrayOfTutorial = arrayOfTabImages
            }
        } else {
            if isFromUserSwipeScreen {
                arrayOfTutorial = arrayOfUserSwipeImagesScale2
            } else if isFromActivitySwipeScreen {
                arrayOfTutorial = arrayOfActivitySwipeImagesScale2
            } else if isFromActivitiesScreen {
                arrayOfTutorial = arrayOfActivitiesTabImagesScale2
            } else {
                arrayOfTutorial = arrayOfTabImagesScale2
            }
        }
    }
    
    private func imageNameConfig() -> String {
        return getLanguage() + "_" + arrayOfTutorial[currentIndex]
    }
}

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView(isPresented: .constant(true),
                  isFromUserSwipeScreen: false,
                  isFromActivitySwipeScreen: false,
                  isFromActivitiesScreen: false)
    }
}
