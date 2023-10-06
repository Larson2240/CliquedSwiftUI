//
//  PickSubActivityView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 27.05.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PickSubActivityView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
    var isFromEditProfile: Bool
    
    @Binding var activitiesFlowPresented: Bool
    
    @State private var selectPicturesViewPresented = false
    @State private var selectedSubActivities: [Activity] = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                content
                
                presentables
            }
            .background(background)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                
                description
                
                subActivityStack
            }
            .edgesIgnoringSafeArea(.bottom)
            
            continueButton
        }
    }
    
    private var header: some View {
        VStack(spacing: 20) {
            HeaderView(title: Constants.screenTitle_pickSubactivity,
                       backButtonVisible: isFromEditProfile,
                       backAction: { presentationMode.wrappedValue.dismiss() })
            
            OnboardingProgressView(totalSteps: 9, currentStep: 6)
        }
    }
    
    private var description: some View {
        VStack(spacing: 12) {
            Text(Constants.label_pickSubActivityScreenTitle)
                .font(.themeBold(20))
            
            Text(Constants.label_pickSubActivityScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.top)
        .padding(.horizontal)
    }
    
    private var subActivityStack: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                if let user = loggedInUser, let pickedActivities = user.favouriteActivityCategories {
                    ForEach(pickedActivities) { activity in
                        categoryStack(for: activity)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 120)
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
            .padding(30)
        }
    }
    
    private func categoryStack(for activity: Activity) -> some View {
        VStack {
            HStack {
                Image(activity.title + "_icon")
                
                Text(activity.title)
                    .font(.themeMedium(14))
                    .foregroundColor(.colorDarkGrey)
                
                Spacer()
            }
            
            LazyVGrid(columns: columns, spacing: 16) {
                if let allActivities = Constants.activityCategories {
                    ForEach(allActivities) { subCategory in
                        if subCategory.parentID == activity.id {
                            subCategoryCell(title: subCategory.title, isSelected: selectedSubActivities.contains(subCategory)) {
                                subActivityTapped(subActivity: subCategory)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func subCategoryCell(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    Color.colorGreenSelected
                } else {
                    Color.colorLightGrey
                }
                
                Text(title)
                    .font(.themeMedium(15))
                    .foregroundColor(isSelected ? .white : .colorDarkGrey)
            }
        }
        .frame(height: 50)
        .cornerRadius(10)
    }
    
    private var presentables: some View {
        NavigationLink(destination: SelectPicturesView(arrayOfProfileImage: [], isFromEditProfile: false),
                       isActive: $selectPicturesViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func continueAction() {
        guard var user = loggedInUser, let pickedActivities = user.favouriteActivityCategories else { return }
        
        var subActivitiesCount = 0
        
        for pickedActivity in pickedActivities {
            let subActivities = selectedSubActivities.filter({ $0.parentID == pickedActivity.id })
            
            if subActivities.count > 0 {
                subActivitiesCount += 1
            }
        }
        
        if subActivitiesCount >= 3 {
            loggedInUser?.interestedActivitySubcategories = selectedSubActivities.map { $0.id }
            
            selectPicturesViewPresented.toggle()
        } else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_pickSubActivity)
        }
    }
    
    private func subActivityTapped(subActivity: Activity) {
        if selectedSubActivities.contains(subActivity) {
            selectedSubActivities.removeAll(where: { $0 == subActivity })
        } else {
            selectedSubActivities.append(subActivity)
        }
    }
}

struct PickSubActivityView_Previews: PreviewProvider {
    static var previews: some View {
        PickSubActivityView(isFromEditProfile: false, activitiesFlowPresented: .constant(true))
    }
}
