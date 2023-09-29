//
//  PickActivityView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 26.05.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PickActivityView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @StateObject private var viewModel = PickActivityViewModel()
    
    var isFromEditProfile: Bool
    
    @Binding var activitiesFlowPresented: Bool
    
    @State private var selectedActivities: [Activity] = []
    @State private var subActivityViewPresented = false
    
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
        .onAppear { onAppearConfig() }
        .navigationBarHidden(true)
    }
    
    private var content: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                
                description
                
                imagesStack
            }
            
            continueButton
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var header: some View {
        VStack(spacing: 20) {
            HeaderView(title: Constants.screenTitle_pickActivity,
                       backButtonVisible: isFromEditProfile,
                       backAction: { presentationMode.wrappedValue.dismiss() })
            
            if !isFromEditProfile {
                OnboardingProgressView(totalSteps: 9, currentStep: 5)
            }
        }
    }
    
    private var description: some View {
        VStack(spacing: 12) {
            Text(Constants.label_pickActivityScreenTitle)
                .font(.themeBold(20))
            
            Text(Constants.label_pickActivityScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.vertical)
        .padding(.horizontal)
    }
    
    private var imagesStack: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach($viewModel.arrayOfActivity) { activity in
                    if activity.wrappedValue.parentID == nil {
                        cell(activity.wrappedValue)
                            .frame(maxHeight: 210)
                            .cornerRadius(15)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 120)
        }
    }
    
    private func cell(_ activity: Activity) -> some View {
        ZStack {
            let cellWidth = (screenSize.width - 40) / 2
            let cellHeight = cellWidth + (cellWidth * 0.2)
            
            Image(activity.icon ?? "placeholder_activity")
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
            
            Color.black
                .opacity(activityIsSelected(activity) ? 0.6 : 0)
                .animation(.default, value: selectedActivities.count)
            
            Image("ic_category_selectiontick")
                .opacity(activityIsSelected(activity) ? 1 : 0)
                .animation(.default, value: selectedActivities.count)
        }
        .onTapGesture {
            cellTap(for: activity)
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
    
    private var continueButton: some View {
        VStack {
            Spacer()
            
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
            .padding(.bottom, safeAreaInsets.bottom == 0 ? 16 : safeAreaInsets.bottom)
            .padding(.top, 16)
        }
    }
    
    private var presentables: some View {
        NavigationLink(destination: PickSubActivityView(isFromEditProfile: isFromEditProfile,
                                                        activitiesFlowPresented: $activitiesFlowPresented),
                       isActive: $subActivityViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func onAppearConfig() {
        viewModel.callGetActivityDataAPI {
            setupSelectedActivity()
        }
        
        if isFromEditProfile {
            setupSelectedActivity()
        }
    }
    
    private func continueAction() {
        guard selectedActivities.count >= 3 else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_pickActivity)
            return
        }
        
        guard var user = Constants.loggedInUser else { return }
        
        user.interestedActivityCategories = selectedActivities.map { $0.id }
        Constants.saveUser(user: user)
        
        subActivityViewPresented.toggle()
    }
    
    private func setupSelectedActivity() {
        guard let user = Constants.loggedInUser, let activities = user.interestedActivityCategories else { return }
        
        for activity in viewModel.arrayOfActivity {
            if activities.contains(activity.id) {
                selectedActivities.append(activity)
            }
        }
    }
    
    private func cellTap(for activity: Activity) {
        if selectedActivities.contains(activity) {
            selectedActivities.removeAll(where: { $0 == activity })
        } else {
            selectedActivities.append(activity)
        }
    }
    
    private func activityIsSelected(_ activity: Activity) -> Bool {
        return selectedActivities.contains(activity)
    }
}

struct PickActivityView_Previews: PreviewProvider {
    static var previews: some View {
        PickActivityView(isFromEditProfile: false, activitiesFlowPresented: .constant(true))
    }
}
