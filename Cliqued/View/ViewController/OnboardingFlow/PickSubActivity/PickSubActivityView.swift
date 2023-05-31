//
//  PickSubActivityView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 27.05.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PickSubActivityView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel.shared
    @StateObject private var subActivityViewModel = PickSubActivityViewModel.shared
    
    var isFromEditProfile: Bool
    var categoryIds: String
    var arrayOfSubActivity: [UserInterestedCategory]
    
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
    }
    
    private var background: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(width: screenSize.width, height: screenSize.height)
    }
    
    private var header: some View {
        HeaderView(title: Constants.screenTitle_pickSubactivity,
                   backButtonVisible: true)
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
        .padding(.top, 40)
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
        .padding(.bottom, 30)
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
                
            } else {
                selectPicturesViewPresented.toggle()
            }
        }
    }
    
    private func continueAction() {
        var isSubCatSelectedFromEveryCategory = false
        
        for i in subActivityViewModel.getActivityAllData() {
            if subActivityViewModel.getSelectedSubActivity().firstIndex(where: { $0.activityCategoryId == "\(i.id ?? 0)"}) != nil {
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
            if subActivityViewModel.getSelectedSubActivity().contains(where: { $0.activityCategoryId == "\(activityData.activityId ?? 0)" && $0.activitySubCategoryId == "\(activityData.subActivityId ?? 0)"}) == false {
                var dic = structPickSubActivityParams()
                dic.activityCategoryId = "\(activityData.activityId ?? 0)"
                dic.activitySubCategoryId = "\(activityData.subActivityId ?? 0)"
                subActivityViewModel.setSubActivity(value: dic)
                subActivityViewModel.setAllSelectedSubActivity(value: dic)
            }
        }
    }
    
    private func subActivityTapped(activity: ActivityCategoryClass, subActivity: SubCategory) {
        if subActivityViewModel.getNumberOfActivity() != 0 {
            if subActivityViewModel.getSelectedSubActivity().contains(where: { $0.activityCategoryId == "\(activity.id ?? 0)" && $0.activitySubCategoryId == "\(subActivity.id ?? 0)"}) {
                if let index = subActivityViewModel.getSelectedSubActivity().firstIndex(where: { $0.activityCategoryId == "\(activity.id ?? 0)" && $0.activitySubCategoryId == "\(subActivity.id ?? 0)"}) {
                    subActivityViewModel.removeSelectedSubActivity(at: index)
                }
            } else {
                var dict = structPickSubActivityParams()
                dict.activityCategoryId = activity.id?.description ?? ""
                dict.activitySubCategoryId = subActivity.id?.description ?? ""
                subActivityViewModel.setSubActivity(value: dict)
            }
        }
    }
}

struct PickSubActivityView_Previews: PreviewProvider {
    static var previews: some View {
        PickSubActivityView(isFromEditProfile: false, categoryIds: "", arrayOfSubActivity: [])
    }
}
