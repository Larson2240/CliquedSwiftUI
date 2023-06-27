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
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @StateObject private var onboardingViewModel = OnboardingViewModel.shared
    @StateObject private var subActivityViewModel = PickSubActivityViewModel()
    
    var isFromEditProfile: Bool
    var categoryIds: String
    var arrayOfSubActivity: [UserInterestedCategory]
    
    @Binding var activitiesFlowPresented: Bool
    
    @State private var selectPicturesViewPresented = false
    
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
            .onAppear { onAppearConfig() }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            header
            
            description
            
            subActivityStack
            
            continueButton
        }
        .edgesIgnoringSafeArea(.bottom)
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
                ForEach($subActivityViewModel.arrayOfActivity) { activity in
                    categoryStack(for: activity.wrappedValue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
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
        .padding(.bottom, safeAreaInsets.bottom == 0 ? 16 : safeAreaInsets.bottom)
        .padding(.top, 16)
    }
    
    private func categoryStack(for activity: ActivityCategoryClass) -> some View {
        VStack {
            HStack {
                if let imageString = activity.icon?.replacingOccurrences(of: ".png", with: "") {
                    Image(imageString)
                }
                
                Text(activity.title ?? "")
                    .font(.themeMedium(14))
                    .foregroundColor(.colorDarkGrey)
                
                Spacer()
            }
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(activity.subCategory ?? []) { subCategory in
                    subCategoryCell(title: subCategory.title ?? "", isSelected: subActivityViewModel.arrayOfSelectedSubActivity.map { $0.activitySubCategoryId }.contains(String(subCategory.id ?? 0))) {
                        subActivityTapped(activity: activity, subActivity: subCategory)
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
    
    private func onAppearConfig() {
        subActivityViewModel.callGetActivityDataAPI(categoryIDs: categoryIds)
        
        if isFromEditProfile {
            setupSelectedSubActivity()
        }
        
        onboardingViewModel.nextAction = {
            if isFromEditProfile {
                activitiesFlowPresented.toggle()
            } else {
                selectPicturesViewPresented.toggle()
            }
        }
    }
    
    private func continueAction() {
        var isSubCatSelectedFromEveryCategory = false
        
        for i in subActivityViewModel.arrayOfActivity {
            if subActivityViewModel.arrayOfSelectedSubActivity.firstIndex(where: { $0.activityCategoryId == "\(i.id ?? 0)"}) != nil {
                isSubCatSelectedFromEveryCategory = true
            } else {
                isSubCatSelectedFromEveryCategory = false
                break
            }
        }
        
        if isSubCatSelectedFromEveryCategory {
            onboardingViewModel.pickActivities = subActivityViewModel.convertSubActivityStructToString()
            
            if isFromEditProfile {
                onboardingViewModel.profileSetupType = ProfileSetupType().completed
            } else {
                onboardingViewModel.profileSetupType = ProfileSetupType().sub_category
            }
            
            onboardingViewModel.callSignUpProcessAPI()
        } else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_pickSubActivity)
        }
    }
    
    private func setupSelectedSubActivity() {
        for activityData in arrayOfSubActivity {
            if subActivityViewModel.arrayOfSelectedSubActivity.contains(where: { $0.activityCategoryId == "\(activityData.activityId ?? 0)" && $0.activitySubCategoryId == "\(activityData.subActivityId ?? 0)"}) == false {
                var dic = structPickSubActivityParams()
                dic.activityCategoryId = "\(activityData.activityId ?? 0)"
                dic.activitySubCategoryId = "\(activityData.subActivityId ?? 0)"
                subActivityViewModel.arrayOfSelectedSubActivity.append(dic)
                subActivityViewModel.arrayOfAllSelectedSubActivity.append(dic)
            }
        }
    }
    
    private func subActivityTapped(activity: ActivityCategoryClass, subActivity: SubCategory) {
        if subActivityViewModel.arrayOfActivity.count != 0 {
            if subActivityViewModel.arrayOfSelectedSubActivity.contains(where: { $0.activityCategoryId == "\(activity.id ?? 0)" && $0.activitySubCategoryId == "\(subActivity.id ?? 0)"}) {
                if let index = subActivityViewModel.arrayOfSelectedSubActivity.firstIndex(where: { $0.activityCategoryId == "\(activity.id ?? 0)" && $0.activitySubCategoryId == "\(subActivity.id ?? 0)"}) {
                    subActivityViewModel.arrayOfSelectedSubActivity.remove(at: index)
                }
            } else {
                var dict = structPickSubActivityParams()
                dict.activityCategoryId = activity.id?.description ?? ""
                dict.activitySubCategoryId = subActivity.id?.description ?? ""
                subActivityViewModel.arrayOfSelectedSubActivity.append(dict)
            }
        }
    }
}

struct PickSubActivityView_Previews: PreviewProvider {
    static var previews: some View {
        PickSubActivityView(isFromEditProfile: false, categoryIds: "", arrayOfSubActivity: [], activitiesFlowPresented: .constant(true))
    }
}
